import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:looks_like_it/imagehash/example/app.dart';
import 'package:looks_like_it/imagehash/imagehash.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(500, 600),
    center: true,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    title: "Looks like it"
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(
    // For widgets to be able to read providers, we need to wrap the entire
    // application in a "ProviderScope" widget.
    // This is where the state of our providers will be stored.
    const ProviderScope(
      child: ImageHashApp(),
    ),
  );
}

void maincli() async {
  // String folderPath = 'C:\\Users\\spenc\\Downloads\\uzi268';
  String folderPath = 'C:\\Users\\spenc\\Downloads\\mel';

  final workerPool = await WorkerPool.create(Platform.numberOfProcessors);
  final memoryLSH = EnhancedLSH(vectorSize: AverageHash.DEFAULT_HASH_SIZE * 8);
  final persistentLSH = PersistentLSH(memoryLSH);
  await persistentLSH.initialize();
  await persistentLSH.loadFromDatabase();

  final processor = StreamingImageProcessor(workerPool, persistentLSH);
  print("Initialized");

  try {
    await for (final similarity in processor.findSimilarImages(
      folderPath,
      threshold: 90.0,
      onError: (error) => print('Error: $error'),
    )) {
      print(similarity);
    }
  } finally {
    await workerPool.close();
    await persistentLSH.isar.close();
  }

  // final workerPool = await WorkerPool.create(Platform.numberOfProcessors);
  // final lsh = EnhancedLSH(vectorSize: AverageHash.DEFAULT_HASH_SIZE * 8);
  // final processor = StreamingImageProcessor(100, workerPool, lsh);

  // try {
  //   print("Looking for similar images");
  //   await for (final similarity in processor.findSimilarImages(
  //     folderPath,
  //     threshold: 90.0,
  //   )) {
  //     print(similarity);
  //   }
  // } finally {
  //   await workerPool.close();
  // }

  // Find similar images in the folder
  // List<ImageSimilarity> similarities =
  //     await AverageHash.findSimilarImagesInFolder(
  //   folderPath,
  //   threshold: 90.0,
  // );

  // print('Similar image pairs:');
  // for (ImageSimilarity similarity in similarities) {
  //   print(similarity);
  // }

  // Use LSH for faster similarity search in a large dataset
  // LocalitySensitiveHashing lsh = LocalitySensitiveHashing();
  // Map<String, Uint8List> allHashes =
  //     await AverageHash.computeHashesForDirectory(folderPath);

  // // Add all hashes to LSH
  // for (var entry in allHashes.entries) {
  //   lsh.addHash(entry.key, entry.value);
  // }

  // Find candidates for a specific image
  // String targetImagePath = 'path/to/target/image.jpg';
  // Uint8List targetHash = await AverageHash.computeHash(targetImagePath);
  // Set<String> candidates = lsh.getCandidates(targetHash);

  // print('Candidate similar images for $targetImagePath:');
  // for (var candidatePath in candidates) {
  //   double similarity =
  //       AverageHash._calculateSimilarity(targetHash, allHashes[candidatePath]!);
  //   print('$candidatePath: ${similarity.toStringAsFixed(2)}%');
  // }
}
