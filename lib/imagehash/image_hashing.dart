import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:looks_like_it/imagehash/example/providers.dart';
import 'package:looks_like_it/providers/files.dart';
import 'package:path/path.dart' as path;
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_hashing.g.dart';

@collection
class ImageEntry {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.hash)
  late String imagePath;

  late List<int> hash;
  late int width;
  late int height;
  late int fileSize;
  late int bitDepth;
  late DateTime lastModified;

  static Future<ImageEntry> fromFile(File file) async {
    final image = await img.decodeImageFile(file.path);

    if (image == null) {
      throw Exception('Unable to decode image: ${file.path}');
    }

    final entry = ImageEntry()
      ..imagePath = file.path
      ..hash = await _computeHash(image)
      ..width = image.width
      ..height = image.height
      ..fileSize = await file.length()
      ..bitDepth = image.bitsPerChannel
      ..lastModified = await file.lastModified();

    return entry;
  }

  static Future<Uint8List> _computeHash(img.Image image) async {
    return AverageHash.computeHash(image);
  }
}

@collection
class ImageSimilarity {
  Id id = Isar.autoIncrement;

  final image1 = IsarLink<ImageEntry>();
  final image2 = IsarLink<ImageEntry>();

  late double similarity;

  @Index()
  late DateTime createdAt;

  ImageSimilarity();

  factory ImageSimilarity.create(
    ImageEntry entry1,
    ImageEntry entry2,
    double similarity,
  ) {
    final imageSimilarity = ImageSimilarity()
      ..image1.value = entry1
      ..image2.value = entry2
      ..similarity = similarity
      ..createdAt = DateTime.now();

    return imageSimilarity;
  }
}

class AverageHash {
  static const int defaultHashSize = 8;
  static const int lshBands = 4;
  static const int lshRows = 16;

  static Future<Uint8List> computeHash(
    img.Image image, {
    int hashSize = defaultHashSize,
  }) async {
    final resultPort = ReceivePort();
    await Isolate.spawn(
      _isolateFunction,
      [
        image,
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
    final img.Image image = args[0];
    final int hashSize = args[1];
    final SendPort sendPort = args[2];

    try {
      final hash = _computeHashInternal(image, hashSize);
      sendPort.send(hash);
    } catch (e) {
      sendPort.send('Error: $e');
    }
  }

  static Uint8List _computeHashInternal(img.Image image, int hashSize) {
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

  static double calculateSimilarity(
    Uint8List hash1,
    Uint8List hash2, {
    int hashSize = defaultHashSize,
  }) {
    int distance = hammingDistance(hash1, hash2);
    int maxDistance = hashSize * hashSize;
    return (1 - distance / maxDistance) * 100;
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

class ImageHashSystem {
  final Isar isar;
  final AdaptiveBatchSizeCalculator batchSizeCalculator;

  static const List<CollectionSchema<dynamic>> schemas = [
    ImageEntrySchema,
    ImageSimilaritySchema,
  ];

  ImageHashSystem({required this.isar})
      : batchSizeCalculator = AdaptiveBatchSizeCalculator(
          maxBatchSize: 300,
          initialBatchSize: 10,
        );

  Future<void> indexImage(File file) async {
    final entry = await ImageEntry.fromFile(file);
    await isar.writeTxn(() async {
      await isar.imageEntrys.put(entry);
    });
  }

  Future<void> indexImages(List<File> files) async {
    for (final file in files) {
      try {
        await indexImage(file);
      } catch (e) {
        // TODO: Notify failure
        continue;
      }
    }
  }

  Future<void> indexFolder(
    String folderPath, {
    bool recursive = false,
  }) async {
    final directory = Directory(folderPath);
    final entities = recursive
        ? directory.list(
            recursive: true,
          )
        : directory.list();
    await for (final entity in entities) {
      if (entity is File && _isImageFile(entity.path)) {
        try {
          await indexImage(entity);
        } catch (e) {
          // TODO: Notify failure
          continue;
        }
      }
    }
  }

  Future<void> compareImages(
    List<String> imagePaths, {
    double threshold = 90.0,
  }) async {
    final istopwatch = Stopwatch()..start();
    final entries = await _getOrIndexEntries(imagePaths);
    istopwatch.stop();
    print("processed in ${istopwatch.elapsedMilliseconds / 1000} seconds");

    final stopwatch = Stopwatch()..start();
    await clearSimilarities();
    await isar.writeTxn(() async {
      for (int i = 0; i < entries.length; i++) {
        for (int j = i + 1; j < entries.length; j++) {
          final similarity = AverageHash.calculateSimilarity(
            Uint8List.fromList(entries[i].hash),
            Uint8List.fromList(entries[j].hash),
          );
          if (similarity >= threshold) {
            final imageSimilarity = ImageSimilarity.create(
              entries[i],
              entries[j],
              similarity,
            );
            await isar.imageSimilaritys.put(imageSimilarity);
            imageSimilarity.image1.save();
            imageSimilarity.image2.save();
          }
        }
      }
    });
    stopwatch.stop();
    print("compared in ${stopwatch.elapsedMilliseconds / 1000} seconds");
  }

  Future<void> compareFolderImages(
    String folderPath, {
    bool recursive = false,
    double threshold = 90.0,
  }) async {
    final paths = await _getImagePathsInFolder(
      folderPath,
      recursive: recursive,
    );

    return compareImages(paths, threshold: threshold);
  }

  Future<List<ImageEntry>> _getOrIndexEntries(List<String> imagePaths) async {
    final entries = <ImageEntry>[];
    final batchSize = batchSizeCalculator.currentBatchSize;

    int batchCount = 1;
    for (var i = 0; i < imagePaths.length; i += batchSize) {
      final stopwatch = Stopwatch()..start();
      print("Processing Batch #${batchCount}");
      final end = (i + batchSize < imagePaths.length)
          ? i + batchSize
          : imagePaths.length;
      final batchPaths = imagePaths.sublist(i, end);

      final batch = isar.imageEntrys.where().anyOf(
            batchPaths,
            (q, filepath) => q.imagePathEqualTo(filepath),
          );

      final existingEntries = await batch.findAll();
      final existingMap = {for (var e in existingEntries) e.imagePath: e};

      await Future.forEach(batchPaths, (filepath) async {
        final existingEntry = existingMap[filepath];
        if (existingEntry != null) {
          final file = File(filepath);
          final lastModified = await file.lastModified();
          if (lastModified == existingEntry.lastModified) {
            entries.add(existingEntry);
            return;
          }
        }
        try {
          final newEntry = await ImageEntry.fromFile(File(filepath));
          await isar.writeTxn(() async {
            await isar.imageEntrys.put(newEntry);
          });
          entries.add(newEntry);
        } catch (e) {
          // Handle or log the error if needed
        }
      });
      stopwatch.stop();
      print(
          "Batch #${batchCount} processed in ${stopwatch.elapsedMilliseconds / 1000} seconds");
      batchCount++;
      // Allow the main thread to process other events
      await Future.delayed(Duration.zero);
    }

    return entries;
  }

  Future<List<String>> _getImagePathsInFolder(
    String folderPath, {
    bool recursive = false,
  }) async {
    final directory = Directory(folderPath);
    final entities = directory.list(
      recursive: recursive,
    );
    final imagePaths = <String>[];
    await for (final entity in entities) {
      if (entity is File && _isImageFile(entity.path)) {
        imagePaths.add(entity.path);
      }
    }
    return imagePaths;
  }

  bool _isImageFile(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    return ['.jpg', '.jpeg', '.png', '.gif', '.bmp'].contains(extension);
  }

  Query<ImageSimilarity> querySimilarities({
    int? limit,
    int? offset,
  }) {
    return isar.imageSimilaritys
        .where()
        .sortBySimilarityDesc()
        .optional(offset != null, (q) => q.offset(offset!))
        .optional(limit != null, (q) => q.limit(limit!))
        .build();
  }

  Future<void> deleteSimilarity(String filePath) async {
    // First try and delete the file
    final file = File(filePath);
    if (!await file.exists()) {
      await _removeSimilarity(filePath);
    }

    await file.delete();

    await _removeSimilarity(filePath);
  }

  Future<void> _removeSimilarity(String filePath) async {
    final entryIds = await isar.imageEntrys
        .where()
        .imagePathEqualTo(filePath)
        .idProperty()
        .findAll();
    final ids = await isar.imageSimilaritys
        .filter()
        .image1((q) {
          return q.imagePathEqualTo(filePath);
        })
        .or()
        .image2((q) {
          return q.imagePathEqualTo(filePath);
        })
        .idProperty()
        .findAll();

    await isar.writeTxn(() async {
      await isar.imageSimilaritys.deleteAll(ids);
      await isar.imageEntrys.deleteAll(entryIds);
    });
  }

  Future<void> clearSimilarities() {
    return isar.writeTxn(() {
      return isar.imageSimilaritys.clear();
    });
  }

  Future<void> clearEntries() {
    return isar.writeTxn(() async {
      await isar.imageSimilaritys.clear();
      await isar.imageEntrys.clear();
    });
  }
}

enum ComparisonType {
  imageList,
  folderImages,
}

@Riverpod(keepAlive: true)
class HashingSystem extends _$HashingSystem {
  @override
  Future<ImageHashSystem> build() async {
    final isar = ref.watch(isarProvider).requireValue;
    final system = ImageHashSystem(
      isar: isar,
    );

    ref.onDispose(() async {
      print("Disposing hashing system");
    });

    return system;
  }
}

@Riverpod(keepAlive: true)
class ComparisonController extends _$ComparisonController {
  @override
  FutureOr<ComparisonType?> build() async {
    final folderPath = ref.watch(directoryPickerProvider);
    final threshold = ref.watch(similarityThresholdProvider);

    if (folderPath == null ||
        folderPath.isEmpty ||
        !await Directory(folderPath).exists()) {
      return null;
    }

    await ref.read(hashingSystemProvider).requireValue.compareFolderImages(
          folderPath,
          recursive: true,
          threshold: threshold,
        );

    return ComparisonType.folderImages;
  }

  Future<void> compareImageList(
    List<String> imagePaths, {
    double threshold = 90.0,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(hashingSystemProvider)
          .requireValue
          .compareImages(imagePaths, threshold: threshold);
      return ComparisonType.imageList;
    });
  }

  Future<void> compareFolderImages(
    String folderPath, {
    bool recursive = false,
    double threshold = 90.0,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      print("running folder comparison");
      await ref.read(hashingSystemProvider).requireValue.compareFolderImages(
          folderPath,
          recursive: recursive,
          threshold: threshold);
      return ComparisonType.folderImages;
    });
  }
}

@riverpod
Stream<void> similaritiesWatcher(SimilaritiesWatcherRef ref) {
  return ref
      .watch(hashingSystemProvider)
      .requireValue
      .querySimilarities()
      .watchLazy();
}

@riverpod
FutureOr<int> similaritiesCount(SimilaritiesCountRef ref) {
  ref.watch(similaritiesWatcherProvider);
  return ref
      .watch(hashingSystemProvider)
      .requireValue
      .querySimilarities()
      .count();
}

@riverpod
class SimilaritiesQuery extends _$SimilaritiesQuery {
  @override
  FutureOr<List<ImageSimilarity>> build({
    int? limit,
    int? offset,
  }) {
    ref.watch(similaritiesWatcherProvider);
    return ref
        .watch(hashingSystemProvider)
        .requireValue
        .querySimilarities(
          limit: limit,
          offset: offset,
        )
        .findAll();
  }
}

@riverpod
class FileOpsController extends _$FileOpsController {
  @override
  FutureOr<void> build() {}

  Future<void> deleteFile(String filePath) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final hashingSystem = await ref.read(hashingSystemProvider.future);
      return hashingSystem.deleteSimilarity(
        filePath,
      );
    });
  }
}
