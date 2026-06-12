import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Service for handling image operations
/// Provides image compression, resizing, and caching
class ImageService {
  static ImageService? _instance;
  static ImageService get instance => _instance ??= ImageService._();

  ImageService._();

  /// Compress image file
  Future<File?> compressImage(
    File file, {
    int quality = 80,
    int maxWidth = 1920,
    int maxHeight = 1080,
  }) async {
    try {
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) return null;

      // Resize if necessary
      img.Image resized = image;
      if (image.width > maxWidth || image.height > maxHeight) {
        resized = img.copyResize(
          image,
          width: maxWidth,
          height: maxHeight,
          maintainAspect: true,
        );
      }

      // Encode with compression
      final compressed = img.encodeJpg(resized, quality: quality);

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
        path.join(tempDir.path, 'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg'),
      );
      await tempFile.writeAsBytes(compressed);

      return tempFile;
    } catch (e) {
      debugPrint('Image compression error: $e');
      return null;
    }
  }

  /// Create thumbnail from image
  Future<File?> createThumbnail(
    File file, {
    int size = 200,
    int quality = 70,
  }) async {
    try {
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) return null;

      // Create square thumbnail
      final thumbnail = img.copyResizeCropSquare(image, size: size);

      // Encode
      final encoded = img.encodeJpg(thumbnail, quality: quality);

      // Save
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
        path.join(tempDir.path, 'thumb_${DateTime.now().millisecondsSinceEpoch}.jpg'),
      );
      await tempFile.writeAsBytes(encoded);

      return tempFile;
    } catch (e) {
      debugPrint('Thumbnail creation error: $e');
      return null;
    }
  }

  /// Resize image to specific dimensions
  Future<File?> resizeImage(
    File file, {
    required int width,
    required int height,
    int quality = 85,
  }) async {
    try {
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) return null;

      // Resize
      final resized = img.copyResize(image, width: width, height: height);

      // Encode
      final encoded = img.encodeJpg(resized, quality: quality);

      // Save
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
        path.join(tempDir.path, 'resized_${DateTime.now().millisecondsSinceEpoch}.jpg'),
      );
      await tempFile.writeAsBytes(encoded);

      return tempFile;
    } catch (e) {
      debugPrint('Image resize error: $e');
      return null;
    }
  }

  /// Get image size in bytes
  Future<int> getImageSize(File file) async {
    final stat = await file.stat();
    return stat.size;
  }

  /// Convert image to base64
  Future<String?> imageToBase64(File file) async {
    try {
      final bytes = await file.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      debugPrint('Image to base64 error: $e');
      return null;
    }
  }

  /// Clear temporary image files
  Future<void> clearTempImages() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final files = tempDir.listSync();

      for (final file in files) {
        if (file is File && (file.path.endsWith('.jpg') || file.path.endsWith('.png'))) {
          if (file.path.contains('compressed_') ||
              file.path.contains('thumb_') ||
              file.path.contains('resized_')) {
            await file.delete();
          }
        }
      }
    } catch (e) {
      debugPrint('Clear temp images error: $e');
    }
  }
}

/// Simple base64 encoding function
String base64Encode(List<int> bytes) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  final buffer = StringBuffer();

  for (var i = 0; i < bytes.length; i += 3) {
    final b1 = bytes[i];
    final b2 = i + 1 < bytes.length ? bytes[i + 1] : 0;
    final b3 = i + 2 < bytes.length ? bytes[i + 2] : 0;

    buffer.write(chars[(b1 >> 2) & 0x3F]);
    buffer.write(chars[((b1 << 4) | (b2 >> 4)) & 0x3F]);
    buffer.write(i + 1 < bytes.length ? chars[((b2 << 2) | (b3 >> 6)) & 0x3F] : '=');
    buffer.write(i + 2 < bytes.length ? chars[b3 & 0x3F] : '=');
  }

  return buffer.toString();
}