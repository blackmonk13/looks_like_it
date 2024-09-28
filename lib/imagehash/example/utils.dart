import 'package:flutter/material.dart';

extension StreamChunked<T> on Stream<T> {
  Stream<List<T>> chunked(int size) {
    return asyncMap((event) => [event]).bufferCount(size);
  }
}

extension IterableBufferCount<T> on Stream<List<T>> {
  Stream<List<T>> bufferCount(int count) async* {
    List<T> buffer = [];
    await for (final chunk in this) {
      buffer.addAll(chunk);
      while (buffer.length >= count) {
        yield buffer.take(count).toList();
        buffer = buffer.skip(count).toList();
      }
    }
    if (buffer.isNotEmpty) {
      yield buffer;
    }
  }
}

Color colorForPercentage(double percentage) {
  if (percentage <= 1) {
    return Colors.red;
  }
  if (percentage >= 100) {
    return Colors.green;
  }

  // Interpolate between green and red
  final intHSL = HSLColor.lerp(
    HSLColor.fromColor(Colors.red),
    HSLColor.fromColor(Colors.green),
    percentage / 100,
  );
  if (intHSL == null) {
    return Colors.black;
  }
  return intHSL.toColor();
}
