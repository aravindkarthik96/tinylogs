import 'package:flutter/services.dart';

import '../logs_data/DatabaseHelper.dart';

class BackupManager {
  static const MethodChannel _channel = MethodChannel('com.tinylogs.app/backup');

  Future<void> backupDataToCloud() async {
    try {
      final String filePath = await DatabaseHelper.instance.exportDataToJson();
      await _channel.invokeMethod('backupData', {'filePath': filePath});
    } on PlatformException catch (e) {
      print("Failed to back up data: '${e.message}'.");
    }
  }
}
