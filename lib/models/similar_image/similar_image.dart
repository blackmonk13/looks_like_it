import 'dart:convert';

import 'package:collection/collection.dart';

import 'image_info.dart';

class SimilarImage {
	String? imagePath;
	String? imageHash;
	ImageInfo? imageInfo;

	SimilarImage({this.imagePath, this.imageHash, this.imageInfo});

	@override
	String toString() {
		return 'SimilarImage(imagePath: $imagePath, imageHash: $imageHash, imageInfo: $imageInfo)';
	}

	factory SimilarImage.fromMap(Map<String, dynamic> data) => SimilarImage(
				imagePath: data['image_path'] as String?,
				imageHash: data['image_hash'] as String?,
				imageInfo: data['image_info'] == null
						? null
						: ImageInfo.fromMap(data['image_info'] as Map<String, dynamic>),
			);

	Map<String, dynamic> toMap() => {
				'image_path': imagePath,
				'image_hash': imageHash,
				'image_info': imageInfo?.toMap(),
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

	@override
	bool operator ==(Object other) {
		if (identical(other, this)) return true;
		if (other is! SimilarImage) return false;
		final mapEquals = const DeepCollectionEquality().equals;
		return mapEquals(other.toMap(), toMap());
	}

	@override
	int get hashCode =>
			imagePath.hashCode ^
			imageHash.hashCode ^
			imageInfo.hashCode;
}
