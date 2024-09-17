import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:crypto/crypto.dart' as crypto;
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

part 'imagehash.g.dart';

@collection
class ImageHash {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.hash)
  late String imagePath;

  late List<int> hash;

  ImageHash(this.imagePath, this.hash);
}

class PersistentLSH {
  late Isar isar;
  final EnhancedLSH memoryLSH;

  PersistentLSH(this.memoryLSH);

  Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ImageHashSchema], directory: dir.path);
  }

  Future<void> addVector(String imagePath, Uint8List hashVector) async {
    memoryLSH.addVector(imagePath, hashVector);
    await isar.writeTxn(() async {
      await isar.imageHashs.put(ImageHash(imagePath, hashVector));
    });
  }

  Future<Set<String>> getCandidates(Uint8List hashVector) async {
    Set<String> candidates = memoryLSH.getCandidates(hashVector);
    // You might want to fetch additional candidates from the database here
    // depending on your specific use case
    return candidates;
  }

  Future<void> loadFromDatabase() async {
    final allHashes = await isar.imageHashs.where().findAll();
    for (final imageHash in allHashes) {
      memoryLSH.addVector(
          imageHash.imagePath, Uint8List.fromList(imageHash.hash));
    }
  }
}

class AdaptiveBatchSizeCalculator {
  final int minBatchSize;
  final int maxBatchSize;
  final int targetProcessingTimeMs;

  int currentBatchSize;
  int lastProcessingTimeMs = 0;

  AdaptiveBatchSizeCalculator({
    this.minBatchSize = 10,
    this.maxBatchSize = 1000,
    this.targetProcessingTimeMs = 1000,
    int initialBatchSize = 100,
  }) : currentBatchSize = initialBatchSize;

  void adjustBatchSize(int processingTimeMs) {
    lastProcessingTimeMs = processingTimeMs;
    if (processingTimeMs > targetProcessingTimeMs) {
      currentBatchSize = max(minBatchSize, currentBatchSize ~/ 2);
    } else if (processingTimeMs < targetProcessingTimeMs ~/ 2) {
      currentBatchSize = min(maxBatchSize, currentBatchSize * 2);
    }
  }
}

class ProgressReporter {
  final int totalFiles;
  int processedFiles = 0;
  final void Function(double progress) onProgress;

  ProgressReporter(this.totalFiles, this.onProgress);

  void update(int newlyProcessedFiles) {
    processedFiles += newlyProcessedFiles;
    double progress = processedFiles / totalFiles;
    onProgress(progress);
  }
}

class AverageHash {
  static const int DEFAULT_HASH_SIZE = 8;
  static const int LSH_BANDS = 4;
  static const int LSH_ROWS = 16;

  static Future<Uint8List> computeHash(String imagePath,
      {int hashSize = DEFAULT_HASH_SIZE}) async {
    return await Isolate.run(() => _computeHashInternal(imagePath, hashSize));
  }

  static Uint8List _computeHashInternal(String imagePath, int hashSize) {
    File imageFile = File(imagePath);
    img.Image? image = img.decodeImage(imageFile.readAsBytesSync());

    if (image == null) {
      throw Exception('Failed to load image: $imagePath');
    }

    img.Image resizedImage = img.copyResize(
      image,
      width: hashSize,
      height: hashSize,
    );

    int totalSum = 0;
    List<int> grayPixels = List.filled(hashSize * hashSize, 0);

    for (int y = 0; y < hashSize; y++) {
      for (int x = 0; x < hashSize; x++) {
        final pixel = resizedImage.getPixel(x, y);
        int gray = (pixel.r + pixel.g + pixel.b) ~/ 3;
        grayPixels[y * hashSize + x] = gray;
        totalSum += gray;
      }
    }

    int average = totalSum ~/ (hashSize * hashSize);

    Uint8List hash = Uint8List((hashSize * hashSize + 7) ~/ 8);
    for (int i = 0; i < grayPixels.length; i++) {
      if (grayPixels[i] > average) {
        hash[i ~/ 8] |= (1 << (7 - (i % 8)));
      }
    }

    return hash;
  }

  static String hashToHex(Uint8List hash) {
    return hash.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }

  static int hammingDistance(Uint8List hash1, Uint8List hash2) {
    if (hash1.length != hash2.length) {
      throw Exception('Hash lengths do not match');
    }

    int distance = 0;
    for (int i = 0; i < hash1.length; i++) {
      int xor = hash1[i] ^ hash2[i];
      distance += xor.toRadixString(2).split('1').length - 1;
    }

    return distance;
  }

  static Future<Map<String, Uint8List>> computeHashesForDirectory(
      String directoryPath,
      {int hashSize = DEFAULT_HASH_SIZE}) async {
    Directory directory = Directory(directoryPath);
    List<FileSystemEntity> files =
        directory.listSync(recursive: true, followLinks: false);

    List<Future<MapEntry<String, Uint8List>>> hashFutures = files
        .where((file) => file is File && _isImageFile(file.path))
        .map((file) async {
      Uint8List hash = await computeHash(file.path, hashSize: hashSize);
      return MapEntry(file.path, hash);
    }).toList();

    List<MapEntry<String, Uint8List>> hashEntries =
        await Future.wait(hashFutures);
    return Map.fromEntries(hashEntries);
  }

  static bool _isImageFile(String filePath) {
    List<String> imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp'];
    return imageExtensions.any((ext) => filePath.toLowerCase().endsWith(ext));
  }

  static Future<List<ImageSimilarity>> findSimilarImagesInFolder(
      String folderPath,
      {int hashSize = DEFAULT_HASH_SIZE,
      double threshold = 90.0}) async {
    Directory directory = Directory(folderPath);
    List<FileSystemEntity> files = directory
        .listSync(recursive: true, followLinks: false)
        .where((file) => file is File && _isImageFile(file.path))
        .toList();

    Map<String, Uint8List> hashes =
        await computeHashesForFiles(files.cast<File>(), hashSize: hashSize);

    List<ImageSimilarity> similarities = [];
    for (var entry in hashes.entries) {
      List<ImageSimilarity> similar = await _findSimilarToImage(
          entry.key, entry.value, hashes,
          threshold: threshold);
      similarities.addAll(similar);
    }

    // Remove duplicates and sort
    return similarities.toSet().toList()
      ..sort((a, b) => b.similarity.compareTo(a.similarity));
  }

  static Future<List<ImageSimilarity>> _findSimilarToImage(
    String imagePath,
    Uint8List imageHash,
    Map<String, Uint8List> allHashes, {
    double threshold = 90.0,
  }) async {
    List<ImageSimilarity> similarities = [];

    for (var entry in allHashes.entries) {
      if (entry.key != imagePath) {
        double similarity = _calculateSimilarity(
          imageHash,
          entry.value,
          DEFAULT_HASH_SIZE,
        );
        if (similarity >= threshold) {
          similarities.add(ImageSimilarity(imagePath, entry.key, similarity));
        }
      }
    }

    return similarities;
  }

  static Future<Map<String, Uint8List>> computeHashesForFiles(List<File> files,
      {int hashSize = DEFAULT_HASH_SIZE}) async {
    final pool = await WorkerPool.create(Platform.numberOfProcessors);
    try {
      List<Future<MapEntry<String, Uint8List>>> hashFutures =
          files.map((file) async {
        Uint8List hash = await pool.computeHash(file.path, hashSize);
        return MapEntry(file.path, hash);
      }).toList();

      List<MapEntry<String, Uint8List>> hashEntries =
          await Future.wait(hashFutures);
      return Map.fromEntries(hashEntries);
    } finally {
      await pool.close();
    }
  }

  static Future<MapEntry<String, Uint8List>> _computeHashForFile(
    List<dynamic> args,
  ) async {
    String filePath = args[0];
    int hashSize = args[1];
    Uint8List hash = await computeHash(filePath, hashSize: hashSize);
    return MapEntry(filePath, hash);
  }

  static double _calculateSimilarity(
    Uint8List hash1,
    Uint8List hash2,
    int hashSize,
  ) {
    int distance = hammingDistance(hash1, hash2);
    int maxDistance = hashSize * hashSize;
    return (1 - distance / maxDistance) * 100;
  }
}

class LocalitySensitiveHashing {
  final int bands;
  final int rows;
  final Map<int, Set<String>> hashTables = {};

  LocalitySensitiveHashing({
    this.bands = AverageHash.LSH_BANDS,
    this.rows = AverageHash.LSH_ROWS,
  });

  void addHash(String imagePath, Uint8List hash) {
    List<int> signature = _minHash(hash);
    for (int i = 0; i < bands; i++) {
      int bandHash = _hashBand(signature.sublist(i * rows, (i + 1) * rows));
      hashTables.putIfAbsent(bandHash, () => {}).add(imagePath);
    }
  }

  Set<String> getCandidates(Uint8List hash) {
    List<int> signature = _minHash(hash);
    Set<String> candidates = {};
    for (int i = 0; i < bands; i++) {
      int bandHash = _hashBand(signature.sublist(i * rows, (i + 1) * rows));
      candidates.addAll(hashTables[bandHash] ?? {});
    }
    return candidates;
  }

  List<int> _minHash(Uint8List hash) {
    Random random = Random(42); // Fixed seed for consistency
    return List.generate(
        bands * rows, (_) => _simHash(hash, random.nextInt(1 << 32)));
  }

  int _simHash(Uint8List hash, int seed) {
    int result = 0;
    for (int i = 0; i < hash.length; i++) {
      if ((hash[i] & (1 << (i % 8))) != 0) {
        result ^= seed;
      }
      seed = _murmurHash(seed);
    }
    return result;
  }

  int _murmurHash(int h) {
    h ^= h >> 16;
    h *= 0x85ebca6b;
    h ^= h >> 13;
    h *= 0xc2b2ae35;
    h ^= h >> 16;
    return h;
  }

  int _hashBand(List<int> band) => band.fold(0, (a, b) => a ^ b);
}

enum WorkerFunction {
  computeHash,
  // Add other function identifiers as needed
}

class WorkerPool {
  final List<Isolate> _isolates = [];
  final List<SendPort> _sendPorts = [];
  final ReceivePort _receivePort = ReceivePort();
  final Map<int, Completer<dynamic>> _completers = {};
  int _nextTaskId = 0;

  WorkerPool._();

  static Future<WorkerPool> create(int numWorkers) async {
    final pool = WorkerPool._();
    await pool._initialize(numWorkers);
    return pool;
  }

  Future<void> _initialize(int numWorkers) async {
    for (int i = 0; i < numWorkers; i++) {
      final isolate =
          await Isolate.spawn(_workerEntryPoint, _receivePort.sendPort);
      _isolates.add(isolate);
    }

    _receivePort.listen((message) {
      if (message is SendPort) {
        _sendPorts.add(message);
      } else if (message is List && message.length == 2) {
        final taskId = message[0] as int;
        final result = message[1];
        _completers[taskId]?.complete(result);
        _completers.remove(taskId);
      }
    });

    // Wait for all workers to initialize
    while (_sendPorts.length < numWorkers) {
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }

  Future<Uint8List> computeHash(String filePath, int hashSize) async {
    return await _computeInWorker(
      WorkerFunction.computeHash,
      [filePath, hashSize],
    );
  }

  Future<T> _computeInWorker<T>(
    WorkerFunction function,
    List<dynamic> args,
  ) async {
    final taskId = _nextTaskId++;
    final completer = Completer<T>();
    _completers[taskId] = completer;

    final workerIndex = taskId % _sendPorts.length;
    _sendPorts[workerIndex].send([taskId, function.index, args]);

    return completer.future;
  }

  Future<void> close() async {
    for (final isolate in _isolates) {
      isolate.kill(priority: Isolate.immediate);
    }
    _isolates.clear();
    _sendPorts.clear();
    _completers.clear();
    _receivePort.close();
  }

  static void _workerEntryPoint(SendPort mainSendPort) {
    final receivePort = ReceivePort();
    mainSendPort.send(receivePort.sendPort);

    receivePort.listen((message) async {
      if (message is List && message.length == 3) {
        final taskId = message[0] as int;
        final functionIndex = message[1] as int;
        final args = message[2] as List<dynamic>;

        dynamic result;
        switch (WorkerFunction.values[functionIndex]) {
          case WorkerFunction.computeHash:
            result = await AverageHash.computeHash(
              args[0] as String,
              hashSize: args[1] as int,
            );
            break;
          // Add other cases as needed
        }

        mainSendPort.send([taskId, result]);
      }
    });
  }
}

class EnhancedLSH {
  final int numHashFunctions;
  final int numBands;
  final int bandSize;
  final List<List<int>> hashFunctions;
  final Map<int, Set<String>> hashTables = {};

  EnhancedLSH(
      {this.numHashFunctions = 100,
      this.numBands = 20,
      required int vectorSize})
      : bandSize = numHashFunctions ~/ numBands,
        hashFunctions = List.generate(
          numHashFunctions,
          (_) => List.generate(vectorSize, (_) => Random().nextInt(2)),
        );

  void addVector(String imagePath, Uint8List hashVector) {
    List<int> signature = _computeSignature(hashVector);
    for (int i = 0; i < numBands; i++) {
      int bandHash =
          _hashBand(signature.sublist(i * bandSize, (i + 1) * bandSize));
      hashTables.putIfAbsent(bandHash, () => {}).add(imagePath);
    }
  }

  Set<String> getCandidates(Uint8List hashVector) {
    List<int> signature = _computeSignature(hashVector);
    Set<String> candidates = {};
    for (int i = 0; i < numBands; i++) {
      int bandHash =
          _hashBand(signature.sublist(i * bandSize, (i + 1) * bandSize));
      candidates.addAll(hashTables[bandHash] ?? {});
    }
    return candidates;
  }

  List<int> _computeSignature(Uint8List hashVector) {
    return List.generate(numHashFunctions, (i) {
      int dotProduct = 0;
      for (int j = 0; j < hashVector.length; j++) {
        dotProduct += hashVector[j] * hashFunctions[i][j];
      }
      return dotProduct > 0 ? 1 : 0;
    });
  }

  int _hashBand(List<int> band) {
    return crypto.md5.convert(Uint8List.fromList(band)).hashCode;
  }
}

class StreamingImageProcessor {
  final WorkerPool workerPool;
  final PersistentLSH lsh;
  final AdaptiveBatchSizeCalculator batchSizeCalculator;

  StreamingImageProcessor(this.workerPool, this.lsh)
      : batchSizeCalculator = AdaptiveBatchSizeCalculator();

  Stream<ImageSimilarity> findSimilarImages(
    String folderPath, {
    double threshold = 90.0,
    void Function(String message)? onError,
  }) async* {
    final directory = Directory(folderPath);
    final files = directory
        .list()
        .where((entity) => entity is File && _isImageFile(entity.path));

    await for (final batch in files
        .asyncMap((file) => file as File)
        .chunked(batchSizeCalculator.currentBatchSize)) {
      final stopwatch = Stopwatch()..start();

      try {
        final batchHashes = await _computeHashesForBatch(batch);

        for (final newEntry in batchHashes.entries) {
          final candidates = await lsh.getCandidates(newEntry.value);
          for (final candidatePath in candidates) {
            final candidateHash = await _getHashFromDatabase(candidatePath);
            if (candidateHash != null) {
              final similarity =
                  _calculateSimilarity(newEntry.value, candidateHash);
              if (similarity >= threshold) {
                yield ImageSimilarity(newEntry.key, candidatePath, similarity);
              }
            }
          }
        }

        for (int i = 0; i < batchHashes.length; i++) {
          final entry1 = batchHashes.entries.elementAt(i);
          for (int j = i + 1; j < batchHashes.length; j++) {
            final entry2 = batchHashes.entries.elementAt(j);
            final similarity = _calculateSimilarity(entry1.value, entry2.value);
            if (similarity >= threshold) {
              yield ImageSimilarity(entry1.key, entry2.key, similarity);
            }
          }
        }

        for (final entry in batchHashes.entries) {
          await lsh.addVector(entry.key, entry.value);
        }
      } catch (e, stackTrace) {
        onError?.call("Error processing batch: $e\n$stackTrace");
      }

      stopwatch.stop();
      batchSizeCalculator.adjustBatchSize(stopwatch.elapsedMilliseconds);
    }
  }

  Future<Map<String, Uint8List>> _computeHashesForBatch(
      List<File> batch) async {
    final hashFutures = batch.map((file) => _computeSingleHash(file));
    final hashes = await Future.wait(hashFutures);
    return Map.fromIterables(batch.map((f) => f.path), hashes);
  }

  Future<Uint8List> _computeSingleHash(File file) async {
    try {
      return await workerPool.computeHash(
          file.path, AverageHash.DEFAULT_HASH_SIZE);
    } catch (e) {
      print("Error computing hash for ${file.path}: $e");
      // Return a placeholder hash or rethrow based on your error handling strategy
      return Uint8List(AverageHash.DEFAULT_HASH_SIZE);
    }
  }

  Future<Uint8List?> _getHashFromDatabase(String imagePath) async {
    final imageHash = await lsh.isar.imageHashs
        .where()
        .imagePathEqualTo(imagePath)
        .findFirst();
    return imageHash != null ? Uint8List.fromList(imageHash.hash) : null;
  }

  bool _isImageFile(String path) {
    final lowercasePath = path.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp']
        .any((ext) => lowercasePath.endsWith('.$ext'));
  }

  double _calculateSimilarity(Uint8List hash1, Uint8List hash2) {
    int distance = AverageHash.hammingDistance(hash1, hash2);
    return (1 - distance / (hash1.length * 8)) * 100;
  }
}

extension StreamChunked<T> on Stream<T> {
  Stream<List<T>> chunked(int size) {
    return asyncMap((event) => [event]).bufferCount(size);
  }
}

extension IterableBufferCount<T> on Stream<List<T>> {
  Stream<List<T>> bufferCount(int count) async* {
    List<T> buffer = [];
    await for (final chunk in this) {
      buffer.addAll(chunk);
      while (buffer.length >= count) {
        yield buffer.take(count).toList();
        buffer = buffer.skip(count).toList();
      }
    }
    if (buffer.isNotEmpty) {
      yield buffer;
    }
  }
}

class ImageSimilarity {
  final String image1Path;
  final String image2Path;
  final double similarity;

  ImageSimilarity(this.image1Path, this.image2Path, this.similarity);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageSimilarity &&
          runtimeType == other.runtimeType &&
          image1Path == other.image1Path &&
          image2Path == other.image2Path;

  @override
  int get hashCode => image1Path.hashCode ^ image2Path.hashCode;

  @override
  String toString() =>
      'ImageSimilarity(image1: $image1Path, image2: $image2Path, similarity: ${similarity.toStringAsFixed(2)}%)';
}

void main() async {
  String folderPath = 'C:\\Users\\spenc\\Downloads\\uzi268';

  final workerPool = await WorkerPool.create(Platform.numberOfProcessors);
  final memoryLSH = EnhancedLSH(vectorSize: AverageHash.DEFAULT_HASH_SIZE * 8);
  final persistentLSH = PersistentLSH(memoryLSH);
  await persistentLSH.initialize();
  await persistentLSH.loadFromDatabase();

  final processor = StreamingImageProcessor(workerPool, persistentLSH);

  try {
    await for (final similarity in processor.findSimilarImages(
      folderPath,
      threshold: 90.0,
      onError: (error) => print('Error: $error'),
    )) {
      print(similarity);
    }
  } finally {
    await workerPool.close();
    await persistentLSH.isar.close();
  }

  // final workerPool = await WorkerPool.create(Platform.numberOfProcessors);
  // final lsh = EnhancedLSH(vectorSize: AverageHash.DEFAULT_HASH_SIZE * 8);
  // final processor = StreamingImageProcessor(100, workerPool, lsh);

  // try {
  //   print("Looking for similar images");
  //   await for (final similarity in processor.findSimilarImages(
  //     folderPath,
  //     threshold: 90.0,
  //   )) {
  //     print(similarity);
  //   }
  // } finally {
  //   await workerPool.close();
  // }

  // Find similar images in the folder
  // List<ImageSimilarity> similarities =
  //     await AverageHash.findSimilarImagesInFolder(
  //   folderPath,
  //   threshold: 90.0,
  // );

  // print('Similar image pairs:');
  // for (ImageSimilarity similarity in similarities) {
  //   print(similarity);
  // }

  // Use LSH for faster similarity search in a large dataset
  // LocalitySensitiveHashing lsh = LocalitySensitiveHashing();
  // Map<String, Uint8List> allHashes =
  //     await AverageHash.computeHashesForDirectory(folderPath);

  // // Add all hashes to LSH
  // for (var entry in allHashes.entries) {
  //   lsh.addHash(entry.key, entry.value);
  // }

  // Find candidates for a specific image
  // String targetImagePath = 'path/to/target/image.jpg';
  // Uint8List targetHash = await AverageHash.computeHash(targetImagePath);
  // Set<String> candidates = lsh.getCandidates(targetHash);

  // print('Candidate similar images for $targetImagePath:');
  // for (var candidatePath in candidates) {
  //   double similarity =
  //       AverageHash._calculateSimilarity(targetHash, allHashes[candidatePath]!);
  //   print('$candidatePath: ${similarity.toStringAsFixed(2)}%');
  // }
}
