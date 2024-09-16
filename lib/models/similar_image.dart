import 'dart:convert';

import 'package:isar/isar.dart';

part 'similar_image.g.dart';

@collection
class SimilarImage {
  Id id = Isar.autoIncrement;

  String imagePath;

  String imageHash;

  int width;

  int height;

  String size;

  final similarities = IsarLinks<SimilarImage>();

  SimilarImage({
    required this.imagePath,
    required this.imageHash,
    required this.width,
    required this.height,
    required this.size,
  });

  @override
  String toString() {
    return imagePath;
  }

  factory SimilarImage.fromMap(Map<String, dynamic> data) {
    final imageInfoMap = data['image_info'] as Map<String, dynamic>;
    final dims = imageInfoMap['dimensions'] as List<dynamic>;
    final size = imageInfoMap['size'] as String;

    int width = 0;
    int height = 0;

    if (dims.isEmpty || dims.length < 2) {
      return SimilarImage(
        imagePath: data['image_path'] as String,
        imageHash: data['image_hash'] as String,
        width: width,
        height: height,
        size: size,
      );
    }

    final w = dims.firstOrNull as int?;
    final h = dims.lastOrNull as int?;

    return SimilarImage(
      imagePath: data['image_path'] as String,
      imageHash: data['image_hash'] as String,
      width: w ?? width,
      height: h ?? height,
      size: size,
    );
  }

  Map<String, dynamic> toMap() => {
        'image_path': imagePath,
        'image_hash': imageHash,
        'image_info': {
          'dimensions': [width, height],
          'size': size,
        },
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SimilarImage].
  factory SimilarImage.fromJson(String data) {
    return SimilarImage.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SimilarImage] to a JSON string.
  String toJson() => json.encode(toMap());
}
