import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:vibration_poc/main.dart';
import 'package:vibration_poc/recorder/service/recorder_controller.dart';

class BackgroundServiceHandler {
  final RecorderController _recorderController;

  const BackgroundServiceHandler(this._recorderController);

  Future<void> startBackgroundService() async {
    if (await _recorderController.hasPermission()) {
      await initializeService();
      if (!kDebugMode) {
        exit(0);
      }
    } else {
      debugPrint("Permission denied. Cannot start background recording.");
    }
  }

  void stopBackgroundService() {
    // TODO(betka): find out how to stop the background service
    // _amplitudeVibrationService.stopVibrating();
    throw UnimplementedError();
  }
}
