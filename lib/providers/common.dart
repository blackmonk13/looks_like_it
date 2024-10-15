import 'dart:io';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:looks_like_it/imagehash/image_hashing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'common.g.dart';

@riverpod
FileImage fileImage(FileImageRef ref, String imagePath) {
  return FileImage(
    File(imagePath),
  );
}

@riverpod
class SelectedImageController extends _$SelectedImageController {
  @override
  int build() {
    return 0;
  }

  void selectImage(int index) {
    state = index;
  }
}

@riverpod
class SelectedId extends _$SelectedId {
  @override
  int build() {
    return 0;
  }

  void selectId(int index) {
    state = index;
  }
}

@riverpod
class SelectedSimilarity extends _$SelectedSimilarity {
  @override
  int build() {
    return 0;
  }

  void selectId(int index) {
    state = index;
  }
}


@Riverpod(keepAlive: true)
FutureOr<Isar> isar(IsarRef ref) async {
  final dir = await getApplicationSupportDirectory();
  final isar = await Isar.open(
    [...ImagesProcessor.schemas],
    directory: dir.path,
    inspector: false,
  );
  ref.onDispose(() => isar.close());
  return isar;
}

@Riverpod(keepAlive: true)
Future<void> appStartup(AppStartupRef ref) async {
  ref.onDispose(() {
    // ensure we invalidate all the providers we depend on
    ref.invalidate(imagesProcessingProvider);
    ref.invalidate(isarProvider);
  });
  // all asynchronous app initialization code should belong here:
  await ref.watch(isarProvider.future);
  await ref.watch(imagesProcessingProvider.future);
  await ref.read(imagesProcessingProvider).requireValue.clearSimilarities();
}

@riverpod
Stream<List<String>> listFolders(ListFoldersRef ref, String folderPath) async* {
  final directory = Directory(folderPath);
  final folders = <String>[];
  await for (var entity in directory.list()) {
    if (entity is Directory) {
      folders.add(entity.path);
      yield folders;
    }
  }
}



@Riverpod(keepAlive: true)
class ScrollPosition extends _$ScrollPosition {
  @override
  double build(String key) {
    return 0.0;
  }

  void updatePosition(double position) {
    state = position;
  }
}

@Riverpod(keepAlive: true)
class SelectedIndex extends _$SelectedIndex {
  @override
  int build() {
    return 0;
  }

  void select(int index) {
    state = index;
  }

  void selectNextOrPrevious(int totalCount) {
    final currentIndex = state;
    if (totalCount > 0) {
      state = currentIndex < totalCount - 1 ? currentIndex : currentIndex - 1;
    } else {
      // FIXME:
      state = 0;
    }
  }
}