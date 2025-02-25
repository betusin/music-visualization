import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration_poc/common/app_root.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';
import 'package:vibration_poc/recorder/service/recorder_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  IocContainer.setup();

  runApp(const AppRoot());
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}

@pragma('vm:entry-point')
bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();

  IocContainer.setup();
  if (Platform.isAndroid) {
    (service as AndroidServiceInstance).setForegroundNotificationInfo(
      title: 'Recording...',
      content: 'Microphone is being used in the background',
    );
  }

  final recorderController = get<RecorderController>();
  recorderController.startRecordingInBackground();

  await for (final future in recorderController.getAmplitudePeriodicStream()) {
    final amplitudeData = await future;
    Vibration.cancel();
    if (amplitudeData != null) {
      Vibration.vibrate(amplitude: (amplitudeData.current.toInt()) + 32);
    }
  }
}
