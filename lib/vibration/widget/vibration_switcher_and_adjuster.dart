import 'package:flutter/material.dart';
import 'package:ui_kit/stream/widget/handling_stream_builder.dart';
import 'package:vibration_poc/common/ui_constants.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';
import 'package:vibration_poc/vibration/service/amplitude_vibration_service.dart';
import 'package:vibration_poc/vibration/util/amplitude_constants.dart';

class VibrationSwitcherAndAdjuster extends StatelessWidget {
  final _amplitudeVibrationService = get<AmplitudeVibrationService>();

  VibrationSwitcherAndAdjuster({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        smallGap,
        HandlingStreamBuilder(
          stream: _amplitudeVibrationService.vibrationOnStream,
          builder: (context, isVibrationOn) {
            return Switch(
              value: isVibrationOn,
              onChanged: (value) => _handleVibrationSwitch(value),
            );
          },
        ),
        _buildAmplitudeSlider(),
      ],
    );
  }

  void _handleVibrationSwitch(bool value) {
    value
        ? _amplitudeVibrationService.vibrateBasedOnAmplitudeFromMicrophone()
        : _amplitudeVibrationService.stopVibrating();
  }

  Widget _buildAmplitudeSlider() {
    return HandlingStreamBuilder(
      stream: _amplitudeVibrationService.amplitudeStream,
      builder: (context, amplitude) {
        return Flexible(
          child: Slider(
            divisions: 15,
            value: amplitude,
            onChanged: (value) => _amplitudeVibrationService.setAmplitude(value),
            min: minAmplitude,
            max: maxAmplitude,
            label: (amplitude).toInt().toString(),
          ),
        );
      },
    );
  }
}
