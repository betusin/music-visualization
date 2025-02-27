import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:vibration_poc/main.dart';
import 'package:vibration_poc/recorder/service/recorder_controller.dart';

class BackgroundServiceHandler {
  final RecorderController _recorderController;

  const BackgroundServiceHandler(this._recorderController);

  Future<void> startBackgroundService() async {
    if (await _recorderController.hasPermission()) {
      await initializeService();
      await Future.delayed(Duration(seconds: 2));
      exit(0);
    } else {
      debugPrint("Permission denied. Cannot start background recording.");
    }
  }

  void stopBackgroundService() {
    final service = FlutterBackgroundService();
    service.invoke("stopVibration");
  }
}
