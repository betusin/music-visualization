import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration_poc/animation/music_animation.dart';
import 'package:vibration_poc/recorder/widget/simple_recorder.dart';
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
          Expanded(child: _buildVibration()),
          Expanded(child: MusicAnimation()),
        ],
      ),
    );
  }

  FutureBuilder<bool?> _buildVibration() {
    // TODO(betka): extract to HandlingFutureBuilder
    return FutureBuilder<bool?>(
        // TODO(betka): support also non-customizable vibrations (Vibration.hasVibration())
        future: Vibration.hasCustomVibrationsSupport(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('While finding Vibrator an error occurred.');
          }

          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          final hasVibrator = snapshot.data ?? false;

          if (!hasVibrator) {
            return Text('Your device does not support customized vibrations.');
          }

          return _buildVibrationContent();
        });
  }

  Widget _buildVibrationContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: VibrationAdjustments(),
    );
  }
}
