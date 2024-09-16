import 'dart:io';
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:image/image.dart' as img;

class AverageHash {
  static Uint8List computeHash(String imagePath, {int hashSize = 8}) {
    // Read the image file
    File imageFile = File(imagePath);
    Uint8List bytes = imageFile.readAsBytesSync();
    img.Image? image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Failed to load image: $imagePath');
    }

    // Resize the image to hashSize x hashSize
    img.Image resizedImage = img.copyResize(
      image,
      width: hashSize,
      height: hashSize,
    );

    // Convert to grayscale and calculate average
    List<int> grayPixels = [];
    int totalSum = 0;

    for (int y = 0; y < hashSize; y++) {
      for (int x = 0; x < hashSize; x++) {
        final pixel = resizedImage.getPixel(x, y);
        num r = pixel.r;
        num g = pixel.g;
        num b = pixel.b;
        int gray = (r + g + b) ~/ 3;
        grayPixels.add(gray);
        totalSum += gray;
      }
    }

    int average = totalSum ~/ (hashSize * hashSize);

    // Compute the hash
    Uint8List hash = Uint8List((hashSize * hashSize + 7) ~/ 8);
    int index = 0;
    int bitIndex = 0;

    for (int gray in grayPixels) {
      if (bitIndex == 8) {
        bitIndex = 0;
        index++;
      }
      if (gray > average) {
        hash[index] |= (1 << (7 - bitIndex));
      }
      bitIndex++;
    }

    return hash;
  }

  static String hashToHex(Uint8List hash) {
    return hash.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }

  static int hammingDistance(Uint8List hash1, Uint8List hash2) {
    if (hash1.length != hash2.length) {
      throw Exception('Hash lengths do not match');
    }

    int distance = 0;
    for (int i = 0; i < hash1.length; i++) {
      int xor = hash1[i] ^ hash2[i];
      distance += xor.toRadixString(2).split('1').length - 1;
    }

    return distance;
  }

  static double compareImages(String imagePath1, String imagePath2,
      {int hashSize = 8}) {
    Uint8List hash1 = computeHash(imagePath1, hashSize: hashSize);
    Uint8List hash2 = computeHash(imagePath2, hashSize: hashSize);

    int distance = hammingDistance(hash1, hash2);
    int maxDistance = hashSize * hashSize;

    // Convert distance to similarity percentage
    return (1 - distance / maxDistance) * 100;
  }
}
