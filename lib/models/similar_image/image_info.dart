import 'dart:convert';

import 'package:collection/collection.dart';

class ImageInfo {
  ({int width, int height})? dimensions;
  String? size;

  ImageInfo({this.dimensions, this.size});

  @override
  String toString() => 'ImageInfo(dimensions: $dimensions, size: $size)';

  factory ImageInfo.fromMap(Map<String, dynamic> data) => ImageInfo(
        dimensions: (() {
          final dims = data['dimensions'] as List<dynamic>?;

          if (dims == null) {
            return (width: 0, height: 0);
          }

          if (dims.isEmpty || dims.length < 2) {
            return (width: 0, height: 0);
          }

          final width = dims.firstOrNull as int?;
          final height = dims.lastOrNull as int?;

          return (width: width ?? 0, height: height ?? 0);
        })(),
        size: data['size'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'dimensions': dimensions,
        'size': size,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ImageInfo].
  factory ImageInfo.fromJson(String data) {
    return ImageInfo.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ImageInfo] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! ImageInfo) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => dimensions.hashCode ^ size.hashCode;
}
