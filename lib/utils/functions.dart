import 'dart:convert';
import 'dart:io';

import 'package:isar/isar.dart';
import 'package:looks_like_it/models/similar_image.dart';
import 'package:path_provider/path_provider.dart';

Future<Isar> getStorage() async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [SimilarImageSchema],
    directory: dir.path,
  );
  return isar;
}

String formatFileSize(String? fileSize) {
  if (fileSize == null || fileSize.isEmpty) return "Unknown size";

  double? sizeInBytes = double.tryParse(fileSize.split(' ')[0]);

  if (sizeInBytes == null) {
    return "Invalid size";
  }

  const units = ["bytes", "KB", "MB", "GB", "TB", "PB"];
  int unitIndex = 0;

  while (sizeInBytes! >= 1024 && unitIndex < units.length - 1) {
    sizeInBytes /= 1024;
    unitIndex++;
  }

  return "${sizeInBytes.toStringAsFixed(2)} ${units[unitIndex]}";
}

Future<String> runStreamed(
  String childProcessName,
  List<String> childArgs, {
  String? workingDirectory,
}) async {
  // Start the child process
  Process process = await Process.start(
    childProcessName,
    childArgs,
    workingDirectory: workingDirectory,
  );

  final output = await process.stdout.transform(utf8.decoder).join();

  // Wait for the child process to complete
  // int exitCode = await process.exitCode;

  // if (exitCode != 0) {
  //   return null;
  // }

  // Print the exit code from the child process
  // print("Child process exited with code $exitCode");

  return output;
}
