import 'dart:io';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:looks_like_it/models/similar_image.dart';
import 'package:looks_like_it/utils/prefs.dart';
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

@riverpod
class SelectedImages extends _$SelectedImages {
  @override
  List<SimilarImage> build() {
    return [];
  }

  void select(SimilarImage value) {
    if (state.any((img) => img.imagePath == value.imagePath)) {
      return;
    }
    state = [...state, value];
  }

  void deselect(SimilarImage value) {
    state = state.where((image) {
      return image.imagePath != value.imagePath;
    }).toList();
  }

  void selectMany(List<SimilarImage> value) {
    final items = value.where((element) {
      return !state.contains(element);
    });
    state = [...state, ...items];
  }

  void deselectMany(List<SimilarImage> value) {
    state = state.where((element) {
      return !value.contains(element);
    }).toList();
  }
}

@Riverpod(keepAlive: true)
FutureOr<Isar> isar(IsarRef ref) async {
  final dir = await getApplicationSupportDirectory();
  final isar = await Isar.open(
    [SimilarImageSchema],
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
    ref.invalidate(sharedPreferencesProvider);
    ref.invalidate(isarProvider);
  });
  // all asynchronous app initialization code should belong here:
  await ref.watch(sharedPreferencesProvider.future);
  await ref.watch(isarProvider.future);
}
