import 'dart:io';

import 'package:looks_like_it/imagehash/example/utils.dart';
import 'package:looks_like_it/imagehash/imagehash.dart';
import 'package:looks_like_it/providers/files.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
class LSH extends _$LSH {
  @override
  Future<PersistentLSH> build() async {
    final memoryLSH = EnhancedLSH(
      vectorSize: AverageHash.DEFAULT_HASH_SIZE * 8,
    );
    final persistentLSH = PersistentLSH(memoryLSH);
    await persistentLSH.initialize();
    await persistentLSH.loadFromDatabase();
    ref.onDispose(() async {
      await persistentLSH.isar.clear();
      await persistentLSH.isar.close();
    });
    return persistentLSH;
  }
}

@Riverpod(keepAlive: true)
class ImageProcessor extends _$ImageProcessor {
  @override
  Future<StreamingImageProcessor> build() async {
    final persistentLSH = ref.watch(lSHProvider).requireValue;
    final workerPool = await WorkerPool.create(
      Platform.numberOfProcessors,
    );
    final processor = StreamingImageProcessor(workerPool, persistentLSH);
    ref.onDispose(() async {
      await workerPool.close();
    });

    return processor;
  }
}

@riverpod
class SimilarityThreshold extends _$SimilarityThreshold {
  @override
  double build() {
    return 90.0;
  }

  void setThreshold(double threshold) {
    state = threshold;
  }
}

@riverpod
Stream<List<ImageSimilarity>> findSimilarities(FindSimilaritiesRef ref) async* {
  final folderPath = ref.watch(directoryPickerProvider);
  final processor = ref.watch(imageProcessorProvider).requireValue;
  final threshold = ref.watch(similarityThresholdProvider);

  List<ImageSimilarity> batch = [];

  if (folderPath == null) {
    yield batch;
    return;
  }

  await for (final chunk in processor
      .findSimilarImages(folderPath, threshold: threshold)
      .chunked(10)) {
    batch.addAll(chunk);
    yield batch;
  }
  // return
  //     .toList()
  //     .asStream();
}

@Riverpod(keepAlive: true)
Future<void> appStartup(AppStartupRef ref) async {
  ref.onDispose(() {
    // ensure we invalidate all the providers we depend on
    ref.invalidate(lSHProvider);
    ref.invalidate(imageProcessorProvider);
  });
  // all asynchronous app initialization code should belong here:
  await ref.watch(lSHProvider.future);
  await ref.watch(imageProcessorProvider.future);
}

@riverpod
FutureOr<ImageMetadata> imageMetadata(ImageMetadataRef ref, String filePath) {
  return ImageMetadata.fromFile(filePath);
}

@riverpod
Stream<List<String>> listFolders(ListFoldersRef ref, String folderPath) async* {
  final directory = Directory(folderPath).parent;
  final folders = <String>[];
  await for (var entity in directory.list()) {
    if (entity is Directory) {
      folders.add(entity.path);
      yield folders;
    }
  }
}
