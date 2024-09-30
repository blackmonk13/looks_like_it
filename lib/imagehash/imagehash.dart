import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:crypto/crypto.dart' as crypto;
import 'package:isar/isar.dart';
import 'package:looks_like_it/imagehash/example/utils.dart';
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
    final dir = await getApplicationSupportDirectory();
    isar = await Isar.open(
      [ImageHashSchema],
      name: "imagehash",
      directory: dir.path,
      inspector: false,
    );
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
        imageHash.imagePath,
        Uint8List.fromList(imageHash.hash),
      );
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
  static const int defaultHashSize = 8;
  static const int lshBands = 4;
  static const int lshRows = 16;

  static Future<Uint8List> computeHash(
    String imagePath, {
    int hashSize = defaultHashSize,
  }) async {
    final resultPort = ReceivePort();
    await Isolate.spawn(
      _isolateFunction,
      [
        imagePath,
        hashSize,
        resultPort.sendPort,
      ],
    );
    final result = await resultPort.first;
    if (result is Uint8List) {
      return result;
    } else {
      throw Exception('Failed to compute hash: $result');
    }
  }

  static void _isolateFunction(List<dynamic> args) {
    final String imagePath = args[0];
    final int hashSize = args[1];
    final SendPort sendPort = args[2];

    try {
      final hash = _computeHashInternal(imagePath, hashSize);
      sendPort.send(hash);
    } catch (e) {
      sendPort.send('Error: $e');
    }
  }

  static Uint8List _computeHashInternal(String imagePath, int hashSize) {
    final bytes = File(imagePath).readAsBytesSync();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Failed to load image: $imagePath');
    }

    final resizedImage = img.copyResize(
      image,
      width: hashSize,
      height: hashSize,
      interpolation: img.Interpolation.average,
    );

    final int pixelCount = hashSize * hashSize;
    final grayPixels = Uint8List(pixelCount);
    int totalSum = 0;

    for (int i = 0; i < pixelCount; i++) {
      final pixel = resizedImage.getPixel(i % hashSize, i ~/ hashSize);
      final gray = (pixel.r + pixel.g + pixel.b) ~/ 3;
      grayPixels[i] = gray;
      totalSum += gray;
    }

    final average = totalSum ~/ pixelCount;
    final hash = Uint8List((pixelCount + 7) ~/ 8);

    for (int i = 0; i < pixelCount; i++) {
      if (grayPixels[i] > average) {
        hash[i >> 3] |= (1 << (7 - (i & 7)));
      }
    }

    return hash;
  }

  static String hashToHex(Uint8List hash) {
    return hash.map((byt) => byt.toRadixString(16).padLeft(2, '0')).join();
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
    String directoryPath, {
    int hashSize = defaultHashSize,
  }) async {
    Directory directory = Directory(directoryPath);
    List<FileSystemEntity> files = directory.listSync(
      recursive: true,
      followLinks: false,
    );

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
    String folderPath, {
    int hashSize = defaultHashSize,
    double threshold = 90.0,
  }) async {
    Directory directory = Directory(folderPath);
    List<FileSystemEntity> files = directory
        .listSync(recursive: true, followLinks: false)
        .where((file) => file is File && _isImageFile(file.path))
        .toList();

    Map<String, Uint8List> hashes = await computeHashesForFiles(
      files.cast<File>(),
      hashSize: hashSize,
    );

    List<ImageSimilarity> similarities = [];
    for (MapEntry<String, Uint8List> entry in hashes.entries) {
      List<ImageSimilarity> similar = await _findSimilarToImage(
        entry.key,
        entry.value,
        hashes,
        threshold: threshold,
      );
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
          defaultHashSize,
        );
        if (similarity >= threshold) {
          similarities.add(ImageSimilarity(imagePath, entry.key, similarity));
        }
      }
    }

    return similarities;
  }

  static Future<Map<String, Uint8List>> computeHashesForFiles(
    List<File> files, {
    int hashSize = defaultHashSize,
  }) async {
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
    this.bands = AverageHash.lshBands,
    this.rows = AverageHash.lshRows,
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
      final isolate = await Isolate.spawn(
        _workerEntryPoint,
        _receivePort.sendPort,
      );
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

  EnhancedLSH({
    this.numHashFunctions = 100,
    this.numBands = 20,
    required int vectorSize,
  })  : bandSize = numHashFunctions ~/ numBands,
        hashFunctions = List.generate(
          numHashFunctions,
          (_) => List.generate(vectorSize, (_) => Random().nextInt(2)),
        );

  void addVector(String imagePath, Uint8List hashVector) {
    List<int> signature = _computeSignature(hashVector);
    for (int i = 0; i < numBands; i++) {
      int bandHash = _hashBand(signature.sublist(
        i * bandSize,
        (i + 1) * bandSize,
      ));
      hashTables.putIfAbsent(bandHash, () => {}).add(imagePath);
    }
  }

  Set<String> getCandidates(Uint8List hashVector) {
    List<int> signature = _computeSignature(hashVector);
    Set<String> candidates = {};
    for (int i = 0; i < numBands; i++) {
      int bandHash = _hashBand(signature.sublist(
        i * bandSize,
        (i + 1) * bandSize,
      ));
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
      : batchSizeCalculator = AdaptiveBatchSizeCalculator(
          maxBatchSize: 300,
          initialBatchSize: 10,
        );

  Stream<ImageSimilarity> findSimilarImages(
    String folderPath, {
    double threshold = 90.0,
    void Function(String message)? onError,
  }) async* {
    final directory = Directory(folderPath);
    print("Scanning for similarities in ${directory.path}");
    final files = directory
        .list(recursive: true)
        .where((entity) => entity is File && _isImageFile(entity.path));
    int batchCount = 1;
    await for (final batch in files
        .asyncMap((file) => file as File)
        .chunked(batchSizeCalculator.currentBatchSize)) {
      final stopwatch = Stopwatch()..start();
      print("Processing Batch #${batchCount}");
      batchCount++;
      try {
        final batchHashes = await _computeHashesForBatch(batch);

        for (final newEntry in batchHashes.entries) {
          final candidates = await lsh.getCandidates(newEntry.value);
          for (final candidatePath in candidates) {
            if (newEntry.key == candidatePath) {
              continue;
            }
            final candidateHash = await _getHashFromDatabase(candidatePath);
            if (candidateHash != null) {
              final similarity = _calculateSimilarity(
                newEntry.value,
                candidateHash,
              );
              if (similarity >= threshold) {
                yield ImageSimilarity(
                  newEntry.key,
                  candidatePath,
                  similarity,
                );
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
      print(
          "Batch #${batchCount} processed in ${stopwatch.elapsedMilliseconds / 1000} seconds");
      batchSizeCalculator.adjustBatchSize(stopwatch.elapsedMilliseconds);
    }
  }

  Future<Map<String, Uint8List>> _computeHashesForBatch(
    List<File> batch,
  ) async {
    final hashFutures = batch.map((file) => _computeSingleHash(file));
    final hashes = await Future.wait(hashFutures);
    return Map.fromIterables(batch.map((f) => f.path), hashes);
  }

  Future<Uint8List> _computeSingleHash(File file) async {
    try {
      return await workerPool.computeHash(
        file.path,
        AverageHash.defaultHashSize,
      );
    } catch (e) {
      print("Error computing hash for ${file.path}: $e");
      // Return a placeholder hash or rethrow
      return Uint8List(AverageHash.defaultHashSize);
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

class ImageMetadata {
  final String path;
  final int width;
  final int height;
  final int fileSize;
  final int bitDepth;
  // final double pixelDensity;

  ImageMetadata({
    required this.path,
    required this.width,
    required this.height,
    required this.fileSize,
    required this.bitDepth,
    // required this.pixelDensity,
  });

  static Future<ImageMetadata> fromFile(String path) async {
    final file = File(path);
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Unable to decode image');
    }

    return ImageMetadata(
      path: path,
      width: image.width,
      height: image.height,
      fileSize: await file.length(),
      bitDepth: image.bitsPerChannel,
    );
  }
}
