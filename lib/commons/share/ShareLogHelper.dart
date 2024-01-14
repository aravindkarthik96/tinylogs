import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class ShareLogHelper {
  static Future<void> captureAndShare(
    ScreenshotController screenshotController,
  ) async {
    try {
      final Uint8List? image = await screenshotController.capture();
      if (image != null) {
        final Directory tempDir = await getTemporaryDirectory();
        final File file =
            await File('${tempDir.path}/screenshot.png').writeAsBytes(image);
        Share.shareXFiles([XFile(file.path)]);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error capturing or sharing image: $e");
      }
    }
  }
}
