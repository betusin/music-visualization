import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class VibrationAccessBuilder extends StatelessWidget {
  final Widget child;
  const VibrationAccessBuilder({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
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
      },
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
      },
    );
  }

  Widget _buildVibrationContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: child,
    );
  }
}
