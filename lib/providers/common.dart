import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:looks_like_it/models/similar_image/similar_image.dart';
import 'package:looks_like_it/utils/functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'common.g.dart';

@Riverpod(keepAlive: true)
class SimilaritiesExecutable extends _$SimilaritiesExecutable {
  @override
  String? build() {
    return null;
  }

  Future<void> pickExecutable() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result == null) {
      // User canceled the picker
      return;
    }

    final xFile = result.files.first.xFile;

    state = xFile.path;
  }
}

@Riverpod(keepAlive: true)
class DirectoryPicker extends _$DirectoryPicker {
  @override
  String? build() {
    return null;
  }

  Future<String?> pickFolder() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) {
      // User canceled the picker
      return null;
    }

    state = selectedDirectory;

    return state;
  }
}

@riverpod
class SimilaritiesController extends _$SimilaritiesController {
  @override
  FutureOr<Map<SimilarImage, List<SimilarImage>>?> build() async {
    final executablePath = ref.watch(similaritiesExecutableProvider);
    final searchPath = ref.watch(directoryPickerProvider);
    if (executablePath == null || searchPath == null) {
      return null;
    }

    final output = await runStreamed(
      executablePath,
      [
        '-t 1',
        searchPath,
      ],
    );

    Map<String, dynamic> similarityData = json.decode(output);

    final similarityGroups = similarityData.map((key, value) {
      final similarities = value as List<dynamic>;
      final similarImages = similarities.map((entity) {
        return SimilarImage.fromMap(entity as Map<String, dynamic>);
      }).toList();

      return MapEntry(similarImages.firstWhere((element) {
        return element.imagePath == key;
      }),
          similarImages.where((element) {
            return element.imagePath != key;
          }).toList());
    });
    return similarityGroups;
  }
}

@riverpod
FileImage fileImage(FileImageRef ref, String imagePath) {
  return FileImage(
    File(imagePath),
  );
}

@riverpod
class SelectionGroup extends _$SelectionGroup {
  @override
  ({int selectedImage, int selectedSimilarity}) build() {
    return (selectedImage: 0, selectedSimilarity: 0);
  }

  void selectImage(int selected) {
    state = (selectedImage: selected, selectedSimilarity: 0);
  }

  void selectSimilarity(int selected) {
    state = (selectedImage: state.selectedImage, selectedSimilarity: selected);
  }
}
