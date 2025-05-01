import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:ui_kit/stream/widget/handling_stream_builder.dart';
import 'package:vibration_poc/common/ui_constants.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';
import 'package:vibration_poc/vibration/service/amplitude_vibration_service.dart';

class VibrationSwitcher extends StatelessWidget {
  final _amplitudeVibrationService = get<AmplitudeVibrationService>();

  final ValueChanged<bool>? onToggle;

  VibrationSwitcher({super.key, this.onToggle});

  @override
  Widget build(BuildContext context) {
    return HandlingStreamBuilder(
      stream: _amplitudeVibrationService.vibrationOnStream,
      builder: (context, isVibrationOn) {
        return FlutterSwitch(
          value: isVibrationOn,
          onToggle: (value) => _handleVibrationSwitch(value),
          activeText: 'Vibration On',
          inactiveText: 'Vibration Off',
          showOnOff: true,
          width: 130,
          activeColor: primaryColor,
        );
      },
    );
  }

  void _handleVibrationSwitch(bool value) {
    if (onToggle != null) {
      onToggle!(value);
      return;
    }

    value ? _amplitudeVibrationService.resumeVibrating() : _amplitudeVibrationService.stopVibrating();
  }
}
