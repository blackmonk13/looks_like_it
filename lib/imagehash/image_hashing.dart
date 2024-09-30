import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:looks_like_it/imagehash/imagehash.dart';
import 'package:path/path.dart' as path;
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

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

  ImageEntry();

  static Future<ImageEntry> fromFile(File file) async {
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Unable to decode image: ${file.path}');
    }

    final entry = ImageEntry()
      ..imagePath = file.path
      ..hash = await _computeHash(file.path)
      ..width = image.width
      ..height = image.height
      ..fileSize = await file.length()
      ..bitDepth = image.bitsPerChannel
      ..lastModified = await file.lastModified();

    return entry;
  }

  static Future<Uint8List> _computeHash(String imagePath) async {
    return AverageHash.computeHash(imagePath);
  }
}

class ImageHashSystem {
  late Isar isar;

  Future<void> initialize() async {
    final dir = await getApplicationSupportDirectory();
    isar = await Isar.open(
      [ImageEntrySchema],
      directory: dir.path,
    );
  }

  Future<void> indexImage(File file) async {
    final entry = await ImageEntry.fromFile(file);
    await isar.writeTxn(() async {
      await isar.imageEntrys.put(entry);
    });
  }

  Future<void> indexImages(List<File> files) async {
    for (final file in files) {
      await indexImage(file);
    }
  }

  Future<void> indexFolder(String folderPath, {bool recursive = false}) async {
    final directory = Directory(folderPath);
    final entities = recursive
        ? directory.list(
            recursive: true,
          )
        : directory.list();
    await for (final entity in entities) {
      if (entity is File && _isImageFile(entity.path)) {
        await indexImage(entity);
      }
    }
  }

  Future<List<ImageSimilarity>> compareImages(
    List<String> imagePaths, {
    double threshold = 90.0,
  }) async {
    final similarities = <ImageSimilarity>[];
    final entries = await _getOrIndexEntries(imagePaths);

    for (int i = 0; i < entries.length; i++) {
      for (int j = i + 1; j < entries.length; j++) {
        final similarity = _calculateSimilarity(
          Uint8List.fromList(entries[i].hash),
          Uint8List.fromList(entries[j].hash),
        );
        if (similarity >= threshold) {
          similarities.add(ImageSimilarity(
            entries[i].imagePath,
            entries[j].imagePath,
            similarity,
          ));
        }
      }
    }

    return similarities;
  }

  Future<List<ImageSimilarity>> compareFolderImages(
    String folderPath, {
    bool recursive = false,
    double threshold = 90.0,
  }) async {
    final paths = await _getImagePathsInFolder(
      folderPath,
      recursive: recursive,
    );
    return compareImages(
      paths,
      threshold: threshold,
    );
  }

  Future<List<ImageSimilarity>> compareFolders(
    String folderPath1,
    String folderPath2, {
    bool recursive = false,
    double threshold = 90.0,
  }) async {
    final paths1 = await _getImagePathsInFolder(
      folderPath1,
      recursive: recursive,
    );
    final paths2 = await _getImagePathsInFolder(
      folderPath2,
      recursive: recursive,
    );
    return compareImages(
      [...paths1, ...paths2],
      threshold: threshold,
    );
  }

  Future<List<ImageEntry>> _getOrIndexEntries(List<String> imagePaths) async {
    final entries = <ImageEntry>[];
    for (final path in imagePaths) {
      final existingEntry =
          await isar.imageEntrys.where().imagePathEqualTo(path).findFirst();
      if (existingEntry != null) {
        final file = File(path);
        final lastModified = await file.lastModified();
        if (lastModified == existingEntry.lastModified) {
          entries.add(existingEntry);
          continue;
        }
      }
      final newEntry = await ImageEntry.fromFile(File(path));
      await isar.writeTxn(() async {
        await isar.imageEntrys.put(newEntry);
      });
      entries.add(newEntry);
    }
    return entries;
  }

  Future<List<String>> _getImagePathsInFolder(
    String folderPath, {
    bool recursive = false,
  }) async {
    final directory = Directory(folderPath);
    final entities = recursive
        ? directory.list(
            recursive: true,
          )
        : directory.list();
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

  double _calculateSimilarity(Uint8List hash1, Uint8List hash2) {
    if (hash1.length != hash2.length) {
      throw Exception('Hash lengths do not match');
    }

    int distance = 0;
    for (int i = 0; i < hash1.length; i++) {
      distance += (hash1[i] ^ hash2[i]).toRadixString(2).split('1').length - 1;
    }

    return (1 - distance / (hash1.length * 8)) * 100;
  }
}

class ImageSimilarity {
  final String image1Path;
  final String image2Path;
  final double similarity;

  ImageSimilarity(
    this.image1Path,
    this.image2Path,
    this.similarity,
  );

  @override
  String toString() =>
      'ImageSimilarity(image1: $image1Path, image2: $image2Path, similarity: ${similarity.toStringAsFixed(2)}%)';
}
