import 'package:flutter/material.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';
import 'package:vibration_poc/vibration/model/vibration_config.dart';
import 'package:vibration_poc/vibration/service/amplitude_vibration_service.dart';

class SmallHomePage extends StatelessWidget {
  final _amplitudeVibrationService = get<AmplitudeVibrationService>();

  SmallHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final mockVibration = VibrationConfig(200, [-5, -20, -20]);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: () => _amplitudeVibrationService.vibrateBasedOnVibrationConfig(mockVibration),
            child: Text('vibrate'),
          ),
        ),
      ),
    );
  }
}
