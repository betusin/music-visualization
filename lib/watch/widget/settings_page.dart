import 'package:flutter/material.dart';
import 'package:master_kit/util/random_id_generator.dart';
import 'package:vibration_poc/auth/service/auth_service.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';
import 'package:vibration_poc/vibration/model/vibration_metadata.dart';
import 'package:vibration_poc/vibration/service/amplitude_vibration_service.dart';
import 'package:vibration_poc/watch/widget/page_wrapper.dart';

class SettingsPage extends StatelessWidget {
  final _amplitudeVibrationService = get<AmplitudeVibrationService>();
  final _authService = get<AuthService>();

  SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mockVibration = VibrationMetadata(generateRandomString(), 200, [-5, -20, -20]);

    return PageWrapper(
      child: Center(
        child: ElevatedButton(
          onPressed: () => _amplitudeVibrationService.vibrateBasedOnVibrationConfig(mockVibration),
          child: Text('vibrate (${_authService.currentUser})'),
        ),
      ),
    );
  }
}
