import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:looks_like_it/imagehash/example/providers.dart';
import 'package:looks_like_it/providers/files.dart';
import 'package:path/path.dart' as path;
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logger/logger.dart';

part 'image_hashing.g.dart';

enum HashAlgorithm { average, difference, wavelet }

abstract class ImageHashing {
  static const int defaultHashSize = 8;

  Uint8List computeHash(img.Image image, {int hashSize = defaultHashSize});

  static ImageHashing getHasher(HashAlgorithm algorithm) {
    switch (algorithm) {
      case HashAlgorithm.average:
        return AverageHash();
      case HashAlgorithm.difference:
        return DifferenceHash();
      case HashAlgorithm.wavelet:
        return WaveletHash();
    }
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

class AverageHash implements ImageHashing {
  @override
  Uint8List computeHash(img.Image image,
      {int hashSize = ImageHashing.defaultHashSize}) {
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
}

class DifferenceHash implements ImageHashing {
  @override
  Uint8List computeHash(img.Image image,
      {int hashSize = ImageHashing.defaultHashSize}) {
    final resizedImage = img.copyResize(
      image,
      width: hashSize + 1,
      height: hashSize,
      interpolation: img.Interpolation.average,
    );

    final int pixelCount = hashSize * hashSize;
    final hash = Uint8List((pixelCount + 7) ~/ 8);

    for (int y = 0; y < hashSize; y++) {
      for (int x = 0; x < hashSize; x++) {
        final pixel1 = resizedImage.getPixel(x, y);
        final pixel2 = resizedImage.getPixel(x + 1, y);
        final gray1 = (pixel1.r + pixel1.g + pixel1.b) ~/ 3;
        final gray2 = (pixel2.r + pixel2.g + pixel2.b) ~/ 3;

        if (gray1 > gray2) {
          final index = y * hashSize + x;
          hash[index ~/ 8] |= (1 << (7 - (index % 8)));
        }
      }
    }

    return hash;
  }
}

class WaveletHash implements ImageHashing {
  @override
  Uint8List computeHash(
    img.Image image, {
    int hashSize = ImageHashing.defaultHashSize,
  }) {
    // Resize image to next power of 2, but cap at 1024 to limit memory usage
    final size =
        math.min(1024, _nextPowerOf2(math.max(image.width, image.height)));
    final resizedImage = img.copyResize(
      image,
      width: size,
      height: size,
      interpolation: img.Interpolation.average,
    );

    // Convert to grayscale and perform wavelet decomposition simultaneously
    final decomposed = _haarWaveletTransform(resizedImage);

    // Extract top-left quadrant (low-frequency component)
    final subImage = _extractSubImage(decomposed, size ~/ 2);

    // Compute hash from the subimage
    return _computeHashFromSubimage(subImage, hashSize);
  }

  int _nextPowerOf2(int n) {
    return 1 << (32 - n.bitLength);
  }

  Float64List _haarWaveletTransform(img.Image image) {
    final size = image.width; // Assume square image
    final data = Float64List(size * size);

    // Convert to grayscale and fill data array
    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        final pixel = image.getPixel(x, y);
        data[y * size + x] = (pixel.r + pixel.g + pixel.b) / 3;
      }
    }

    // Perform wavelet transform
    _haarWavelet2D(data, size);

    return data;
  }

  void _haarWavelet2D(Float64List data, int size) {
    final temp = Float64List(size);

    // Horizontal transform
    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x += 2) {
        int i = y * size + x;
        temp[x ~/ 2] = (data[i] + data[i + 1]) / 2;
        temp[(size + x) ~/ 2] = (data[i] - data[i + 1]) / 2;
      }
      for (int x = 0; x < size; x++) {
        data[y * size + x] = temp[x];
      }
    }

    // Vertical transform
    for (int x = 0; x < size; x++) {
      for (int y = 0; y < size; y += 2) {
        int i = y * size + x;
        temp[y ~/ 2] = (data[i] + data[i + size]) / 2;
        temp[(size + y) ~/ 2] = (data[i] - data[i + size]) / 2;
      }
      for (int y = 0; y < size; y++) {
        data[y * size + x] = temp[y];
      }
    }
  }

  Float64List _extractSubImage(Float64List image, int size) {
    final subImage = Float64List(size * size);
    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        subImage[y * size + x] = image[y * (size * 2) + x];
      }
    }
    return subImage;
  }

  Uint8List _computeHashFromSubimage(Float64List subImage, int hashSize) {
    final hash = Uint8List((hashSize * hashSize + 7) ~/ 8);
    final size = math.sqrt(subImage.length).toInt();
    final scaleX = size / hashSize;
    final scaleY = size / hashSize;

    double sum = 0;
    for (int i = 0; i < subImage.length; i++) {
      sum += subImage[i];
    }
    final average = sum / subImage.length;

    int hashIndex = 0;
    for (int y = 0; y < hashSize; y++) {
      for (int x = 0; x < hashSize; x++) {
        final srcX = (x * scaleX).floor();
        final srcY = (y * scaleY).floor();
        if (subImage[srcY * size + srcX] > average) {
          hash[hashIndex ~/ 8] |= (1 << (7 - (hashIndex % 8)));
        }
        hashIndex++;
      }
    }

    return hash;
  }
}

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
    final image = await optimizedDecodeImage(file);

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
    return ImageHashing.getHasher(HashAlgorithm.difference).computeHash(image);
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

Future<img.Image?> optimizedDecodeImage(File file) async {
  final raf = await file.open(mode: FileMode.read);

  try {
    // Read first 8 bytes for file signature detection
    final headerBytes = await raf.read(8);

    if (headerBytes.length >= 2) {
      if (headerBytes[0] == 0xFF && headerBytes[1] == 0xD8) {
        // It's a JPEG
        await raf.setPosition(0);
        final bytes = await raf.read(await raf.length());
        return img.decodeJpg(bytes);
      } else if (headerBytes.length >= 8 &&
          headerBytes[0] == 0x89 &&
          headerBytes[1] == 0x50 &&
          headerBytes[2] == 0x4E &&
          headerBytes[3] == 0x47 &&
          headerBytes[4] == 0x0D &&
          headerBytes[5] == 0x0A &&
          headerBytes[6] == 0x1A &&
          headerBytes[7] == 0x0A) {
        // It's a PNG
        await raf.setPosition(0);
        final bytes = await raf.read(await raf.length());
        return img.decodePng(bytes);
      }
    }

    // Fallback to generic decoder
    await raf.setPosition(0);
    final bytes = await raf.read(await raf.length());
    return img.decodeImage(bytes);
  } finally {
    await raf.close();
  }
}

img.Image createDifferenceImage(img.Image image1, img.Image image2) {
  // Check if aspect ratios are the same (with some tolerance for floating point comparison)
  double aspectRatio1 = image1.width / image1.height;
  double aspectRatio2 = image2.width / image2.height;
  bool sameAspectRatio = (aspectRatio1 - aspectRatio2).abs() < 0.01;

  img.Image smallerImage;
  img.Image largerImage;

  if (sameAspectRatio) {
    // If aspect ratios are the same, determine which image is smaller
    if (image1.width * image1.height <= image2.width * image2.height) {
      smallerImage = image1;
      largerImage = image2;
    } else {
      smallerImage = image2;
      largerImage = image1;
    }

    // Rescale the larger image to match the smaller one's dimensions
    largerImage = img.copyResize(largerImage,
        width: smallerImage.width,
        height: smallerImage.height,
        interpolation: img.Interpolation.linear);
  } else {
    // If aspect ratios are different, use original images
    smallerImage = image1;
    largerImage = image2;
  }

  // Create a new image with the dimensions of the smaller image
  img.Image differenceImage =
      img.Image(width: smallerImage.width, height: smallerImage.height);

  // Iterate through each pixel
  for (img.Pixel pixel in differenceImage) {
    final x = pixel.x;
    final y = pixel.y;

    // Get pixels from both images
    final pixel1 = smallerImage.getPixel(x, y);
    final pixel2 = largerImage.getPixel(x, y);

    // Calculate the difference for each channel
    // final r = (color1.r - color2.r).abs();
    // final g = (color1.g - color2.g).abs();
    // final b = (color1.b - color2.b).abs();
    // final a = (color1.a - color2.a).abs();

    final isSame = [
      pixel1.r.compareTo(pixel2.r) == 0,
      pixel1.g.compareTo(pixel2.g) == 0,
      pixel1.b.compareTo(pixel2.b) == 0,
      pixel1.a.compareTo(pixel2.a) == 0,
    ].every((e) => e == true);
    final r = isSame ? 0 : 255;
    final g = isSame ? 255 : 0;
    // Set the pixel in the difference image
    pixel
      ..r = r
      ..g = g
      ..b = 0
      ..a = 1;
  }

  return differenceImage;
}

class ImagesProcessor {
  final Isar isar;
  final Logger logger = Logger();

  static const List<CollectionSchema<dynamic>> schemas = [
    ImageEntrySchema,
    ImageSimilaritySchema,
  ];

  ImagesProcessor({required this.isar});

  Future<void> compareImages(
    List<String> imagePaths, {
    double threshold = 90.0,
  }) async {
    await clearSimilarities();
    final istopwatch = Stopwatch()..start();
    final entries = await _getOrIndexEntries(imagePaths);
    istopwatch.stop();
    logger.d("processed in ${istopwatch.elapsedMilliseconds / 1000} seconds");

    final stopwatch = Stopwatch()..start();

    await isar.writeTxn(() async {
      for (int i = 0; i < entries.length; i++) {
        for (int j = i + 1; j < entries.length; j++) {
          final similarity = ImageHashing.calculateSimilarity(
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
    logger.d("compared in ${stopwatch.elapsedMilliseconds / 1000} seconds");
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

  Future<List<ImageEntry>> _getOrIndexEntries(
    List<String> imagePaths,
  ) async {
    final int numberOfIsolates = Platform.numberOfProcessors - 1;
    final chunkSize = (imagePaths.length / numberOfIsolates).ceil();

    final chunks = <List<String>>[];
    for (var i = 0; i < imagePaths.length; i += chunkSize) {
      chunks.add(imagePaths.sublist(
          i,
          i + chunkSize > imagePaths.length
              ? imagePaths.length
              : i + chunkSize));
    }

    final List<Future<List<ImageEntry>>> futures = [];

    for (final chunk in chunks) {
      futures.add(_processChunk(chunk));
    }

    final results = await Future.wait(futures);
    return results.expand((x) => x).toList();
  }

  Future<List<ImageEntry>> _processChunk(List<String> chunk) async {
    final List<ImageEntry> results = [];
    final existingEntries = await isar.imageEntrys
        .where()
        .anyOf(
          chunk,
          (q, filepath) => q.imagePathEqualTo(filepath),
        )
        .findAll();
    final existingMap = {for (var e in existingEntries) e.imagePath: e};
    final existing = chunk.where((e) => existingMap.containsKey(e)).toList();
    final nonexisting =
        chunk.where((e) => !existingMap.containsKey(e)).toList();

    for (var filePath in existing) {
      final existingEntry = existingMap[filePath]!;
      final file = File(filePath);
      final lastModified = await file.lastModified();
      if (lastModified == existingEntry.lastModified) {
        results.add(existingEntry);
      }
    }
    final port = ReceivePort();
    await Isolate.spawn(_isolateFunction, [nonexisting, port.sendPort]);
    final nonExistingResults = await port.first as List<ImageEntry>;
    await isar.writeTxn(() async {
      await isar.imageEntrys.putAll(nonExistingResults);
    });

    results.addAll(nonExistingResults);
    return results;
  }

  static void _isolateFunction(List<dynamic> args) async {
    var logger = Logger();
    List<String> paths = args[0] as List<String>;
    SendPort sendPort = args[1] as SendPort;

    List<ImageEntry> results = [];

    for (final filePath in paths) {
      try {
        final entry = await ImageEntry.fromFile(File(filePath));
        results.add(entry);
      } catch (e) {
        logger.e('Error processing $filePath: $e');
      }
    }

    Isolate.exit(sendPort, results);
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
    Set<String> filePaths = const {},
  }) {
    return isar.imageSimilaritys
        .where()
        .optional(filePaths.isNotEmpty, (q) {
          return q.filter().anyOf(
            filePaths,
            (q, item) {
              return q
                  .image1((q) => q.imagePathEqualTo(item))
                  .or()
                  .image2((q) => q.imagePathEqualTo(item));
            },
          );
        })
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

  Future<Uint8List?> diffImage(String filePath1, String filePath2) async {
    final images = await Future.wait([filePath1, filePath2].map((filePath) {
      return optimizedDecodeImage(File(filePath));
    }));

    if (images.isEmpty || images.length < 2) {
      return null;
    }

    final image1 = images.elementAt(0);
    final image2 = images.elementAt(1);

    if (image1 == null || image2 == null) {
      return null;
    }

    final differenceImage = createDifferenceImage(image1, image2);
    
    return img.encodePng(differenceImage);
  }
}

enum ComparisonType {
  imageList,
  folderImages,
}

@Riverpod(keepAlive: true)
class ImagesProcessing extends _$ImagesProcessing {
  @override
  Future<ImagesProcessor> build() async {
    final isar = ref.watch(isarProvider).requireValue;
    final system = ImagesProcessor(
      isar: isar,
    );

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

    await ref.read(imagesProcessingProvider).requireValue.compareFolderImages(
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
      await ref.read(imagesProcessingProvider).requireValue.compareImages(
            imagePaths,
            threshold: threshold,
          );
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
      await ref.read(imagesProcessingProvider).requireValue.compareFolderImages(
            folderPath,
            recursive: recursive,
            threshold: threshold,
          );
      return ComparisonType.folderImages;
    });
  }
}

@Riverpod(keepAlive: true)
class PathFilters extends _$PathFilters {
  @override
  Set<String> build() {
    return {};
  }

  void toggleFilter(String value) {
    final currentFilters = state;
    if (currentFilters.contains(value)) {
      currentFilters.remove(value);
    } else {
      currentFilters.add(value);
    }

    state = currentFilters;
  }
}

@riverpod
Stream<void> similaritiesWatcher(SimilaritiesWatcherRef ref) {
  return ref
      .watch(imagesProcessingProvider)
      .requireValue
      .querySimilarities()
      .watchLazy();
}

@riverpod
FutureOr<int> similaritiesCount(SimilaritiesCountRef ref) {
  ref.watch(similaritiesWatcherProvider);
  final filePaths = ref.watch(pathFiltersProvider);
  return ref
      .watch(imagesProcessingProvider)
      .requireValue
      .querySimilarities(filePaths: filePaths)
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
    final filePaths = ref.watch(pathFiltersProvider);
    return ref
        .watch(imagesProcessingProvider)
        .requireValue
        .querySimilarities(
          limit: limit,
          offset: offset,
          filePaths: filePaths,
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
      final hashingSystem = await ref.read(imagesProcessingProvider.future);
      return hashingSystem.deleteSimilarity(
        filePath,
      );
    });
  }
}

@riverpod
FutureOr<Uint8List?> differenceImage(
  DifferenceImageRef ref,
  ImageSimilarity similarity,
) {
  final image1 = similarity.image1.value?.imagePath;
  final image2 = similarity.image2.value?.imagePath;

  if (image1 == null || image2 == null) {
    return null;
  }

  return ref.watch(imagesProcessingProvider).requireValue.diffImage(
        image1,
        image2,
      );
}
