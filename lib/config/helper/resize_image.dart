import 'dart:io';
import 'package:image/image.dart' as img;

class ImageUtils {
  /// Resizes the image to the given width while maintaining the aspect ratio
  /// and compresses it with a specified quality.
  /// Returns the resized File for binary uploads.
  static Future<File?> resizeImage(File imageFile,
      {int width = 800, int quality = 80}) async {
    try {
      // Load image as bytes
      final bytes = await imageFile.readAsBytes();

      // Decode image
      final image = img.decodeImage(bytes);
      if (image == null) return null;

      // Resize image
      final resizedImage = img.copyResize(image, width: width);

      // Encode resized image to JPG with the specified quality
      final resizedBytes = img.encodeJpg(resizedImage, quality: quality);

      // Write the resized image to a temporary file
      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/resized_image.jpg');
      await tempFile.writeAsBytes(resizedBytes);

      return tempFile;
    } catch (e) {
      print('Error resizing image: $e');
      return null;
    }
  }
}
