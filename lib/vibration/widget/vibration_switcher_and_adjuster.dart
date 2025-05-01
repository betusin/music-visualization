import 'package:flutter/material.dart';
import 'package:ui_kit/stream/widget/handling_stream_builder.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';
import 'package:vibration_poc/vibration/service/amplitude_vibration_service.dart';
import 'package:vibration_poc/vibration/util/amplitude_constants.dart';
import 'package:vibration_poc/vibration/widget/vibration_switcher.dart';

class VibrationSwitcherAndAdjuster extends StatelessWidget {
  final _amplitudeVibrationService = get<AmplitudeVibrationService>();

  final String? deviceId;

  VibrationSwitcherAndAdjuster({super.key, this.deviceId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VibrationSwitcher(
          deviceId: deviceId,
          onToggle: (value) {
            if (deviceId == null) {
              value
                  ? _amplitudeVibrationService.vibrateBasedOnAmplitudeFromMicrophone()
                  : _amplitudeVibrationService.stopVibrating();
              return;
            }

            value ? _amplitudeVibrationService.resumeVibrating() : _amplitudeVibrationService.pauseVibrating();
          },
        ),
        _buildAmplitudeSlider(),
      ],
    );
  }

  Widget _buildAmplitudeSlider() {
    return HandlingStreamBuilder(
      stream: _amplitudeVibrationService.amplitudeStream,
      builder: (context, amplitude) {
        return Slider(
          divisions: 15,
          value: amplitude,
          onChanged: (value) => _amplitudeVibrationService.setAmplitude(value),
          min: 0,
          max: maxAmplitude,
          label: (amplitude).toInt().toString(),
        );
      },
    );
  }
}
