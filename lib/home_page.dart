import 'package:flutter/material.dart';
import 'package:vibration_poc/animation/music_animation.dart';
import 'package:vibration_poc/background_service/service/background_service_handler.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';
import 'package:vibration_poc/recorder/widget/simple_recorder.dart';
import 'package:vibration_poc/vibration/widget/vibration_access_builder.dart';
import 'package:vibration_poc/vibration/widget/vibration_adjustments.dart';

class HomePage extends StatelessWidget {
  final BackgroundServiceHandler _backgroundServiceHandler = get<BackgroundServiceHandler>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom Vibration Demo')),
      body: Column(
        children: [
          Expanded(child: SimpleRecorder()),
          Expanded(child: VibrationAccessBuilder(child: VibrationAdjustments())),
          Expanded(child: MusicAnimation()),
          Expanded(child: _buildBackgroundServiceButtons()),
        ],
      ),
    );
  }

  Widget _buildBackgroundServiceButtons() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _backgroundServiceHandler.startBackgroundService,
          child: const Text("Quit app and record in the background"),
        ),
        ElevatedButton(
          onPressed: _backgroundServiceHandler.stopBackgroundService,
          child: const Text("Stop recording in the background"),
        ),
      ],
    );
  }
}
