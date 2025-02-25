import 'package:flutter/material.dart';
import 'package:vibration_poc/animation/music_animation.dart';
import 'package:vibration_poc/recorder/widget/simple_recorder.dart';
import 'package:vibration_poc/vibration/widget/vibration_access_builder.dart';
import 'package:vibration_poc/vibration/widget/vibration_adjustments.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom Vibration Demo')),
      body: Column(
        children: [
          Expanded(child: SimpleRecorder()),
          Expanded(child: VibrationAccessBuilder(child: VibrationAdjustments())),
          Expanded(child: MusicAnimation()),
        ],
      ),
    );
  }
}
