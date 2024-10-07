import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:looks_like_it/models/similar_image.dart';
import 'package:looks_like_it/providers/common.dart';
import 'package:looks_like_it/providers/files.dart';
import 'package:looks_like_it/utils/functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path/path.dart' as p;

part 'similarities_repository.g.dart';

class SimilaritiesRepository {
  final String? executablePath;
  final String? folderPath;
  final Isar isar;

  SimilaritiesRepository({
    required this.executablePath,
    required this.folderPath,
    required this.isar,
  });

  Future<void> findSimilarities({
    int threshold = 1,
    bool recursive = true,
  }) async {
    if (executablePath == null) {
      throw Exception("Scan executable not specified");
    }

    if (folderPath == null) {
      throw Exception("Scan folder not specified");
    }

    if (!await File(executablePath!).exists()) {
      throw Exception("Scan executable does not exist");
    }

    if (!await Directory(folderPath!).exists()) {
      throw Exception("Scan directory does not exist");
    }

    final output = await runStreamed(
      executablePath!,
      [
        '-t $threshold',
        if (recursive) '-r',
        folderPath!,
      ],
    );

    Map<String, dynamic> data = json.decode(output);

    final similarityData = data.map((key, value) {
      final similarities = value as List<dynamic>;
      final similarImages = similarities.map((entity) {
        return SimilarImage.fromMap(entity as Map<String, dynamic>);
      }).toList();

      return MapEntry(key, similarImages);
    });

    final similarImages = similarityData.values.map(
      (group) {
        final keyImage = group.first;

        final similarities = group
            .where((image) => image.imagePath != keyImage.imagePath)
            .toList();

        return MapEntry(keyImage, similarities);
      },
    );

    await isar.writeTxn(() async {
      await isar.clear();
      for (var group in similarImages) {
        final key = group.key;
        final values = group.value;
        await isar.similarImages.put(key);
        await isar.similarImages.putAll(values);
      }
    });

    final queryImagesMap = await Future.wait(similarImages.map((group) async {
      final keyPath = group.key.imagePath;
      final valuePaths = group.value.map((e) => e.imagePath);

      final keyImage = await isar.similarImages
          .filter()
          .imagePathEqualTo(keyPath)
          .findFirst();

      final similarities =
          await isar.similarImages.filter().anyOf(valuePaths, (q, i) {
        return q.imagePathEqualTo(i);
      }).findAll();

      return MapEntry(keyImage!, similarities);
    }));

    await isar.writeTxn(() async {
      for (var group in queryImagesMap) {
        final key = group.key;
        final sims = group.value;

        key.similarities.addAll(sims);
        await key.similarities.save();
      }
    });
  }

  Future<bool> deleteImage(SimilarImage image) async {
    final filePath = image.imagePath;

    final imageFile = File(filePath);
    final fileExists = await imageFile.exists();

    if (!fileExists) {
      return false;
    }

    final deletedFile = await imageFile.delete();
    final notDeleted = await deletedFile.exists();

    if (notDeleted) {
      return false;
    }

    debugPrint("${image.imagePath} has been deleted.");

    return true;
  }
}

@riverpod
SimilaritiesRepository similaritiesRepository(SimilaritiesRepositoryRef ref) {
  final isar = ref.watch(isarProvider).requireValue;
  final folderPath = ref.watch(directoryPickerProvider);
  final executablePath = ref.watch(similaritiesExecutableProvider);
  return SimilaritiesRepository(
    executablePath: executablePath,
    folderPath: folderPath,
    isar: isar,
  );
}

@riverpod
FutureOr<void> findSimilarities(
  FindSimilaritiesRef ref, {
  int threshold = 1,
  bool recursive = true,
}) {
  return ref.watch(similaritiesRepositoryProvider).findSimilarities(
        threshold: threshold,
        recursive: recursive,
      );
}

@riverpod
FutureOr<List<SimilarImage>> pagedSimilarities(
  PagedSimilaritiesRef ref,
  int page,
) async {
  ref.watch(similarImagesWatcherProvider);
  final isar = ref.watch(isarProvider).requireValue;

  return isar.similarImages
      .filter()
      .similaritiesIsNotEmpty()
      .sortByImagePath()
      .offset(page)
      .limit(30)
      .findAll();
}

@riverpod
FutureOr<List<SimilarImage>> similarities(SimilaritiesRef ref) {
  final isar = ref.watch(isarProvider).requireValue;
  return isar.similarImages.filter().similaritiesIsNotEmpty().findAll();
}

@riverpod
FutureOr<int> imagesCount(ImagesCountRef ref) {
  final isar = ref.watch(isarProvider).requireValue;
  return isar.similarImages.filter().similaritiesIsNotEmpty().count();
}

@riverpod
FutureOr<SimilarImage?> selectedImage(SelectedImageRef ref) {
  final isar = ref.watch(isarProvider).requireValue;
  final selectedId = ref.watch(selectedIdProvider);
  return isar.similarImages
      .filter()
      .similaritiesIsNotEmpty()
      .idEqualTo(selectedId)
      .findFirst();
}

@riverpod
class DeleteImage extends _$DeleteImage {
  @override
  FutureOr<bool> build(SimilarImage image) {
    return true;
  }

  Future<void> delete() async {
    final isar = ref.read(isarProvider).requireValue;
    final imageName = p.basename(image.imagePath);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final deleted =
          await ref.read(similaritiesRepositoryProvider).deleteImage(image);
      if (!deleted) {
        throw Exception("Failed to delete $imageName");
      }
      final removed = await isar.writeTxn(() async {
        return await isar.similarImages.delete(image.id);
      });
      return removed;
    });
  }
}

@riverpod
Stream<void> similarImagesWatcher(SimilarImagesWatcherRef ref) {
  final isar = ref.watch(isarProvider).requireValue;
  return isar.similarImages.watchLazy(fireImmediately: true);
}
