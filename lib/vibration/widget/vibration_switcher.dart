import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:ui_kit/stream/widget/handling_stream_builder.dart';
import 'package:vibration_poc/common/ui_constants.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';
import 'package:vibration_poc/vibration/service/amplitude_vibration_service.dart';
import 'package:vibration_poc/vibration/service/data_amplitude_vibration_service.dart';

class VibrationSwitcher extends StatefulWidget {
  final ValueChanged<bool>? onToggle;
  final String? deviceId;

  const VibrationSwitcher({super.key, this.onToggle, required this.deviceId});

  @override
  State<VibrationSwitcher> createState() => _VibrationSwitcherState();
}

class _VibrationSwitcherState extends State<VibrationSwitcher> {
  final _amplitudeVibrationService = get<AmplitudeVibrationService>();
  final _dataAmplitudeVibrationService = get<DataAmplitudeVibrationService>();

  @override
  void initState() {
    super.initState();
    if (widget.deviceId != null) {
      // TODO(betka): this can probably be solved better :(
      _dataAmplitudeVibrationService.stopStreamingVibrationMetadata();
      _dataAmplitudeVibrationService.vibrateBasedOnDeviceId(widget.deviceId!);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _dataAmplitudeVibrationService.stopStreamingVibrationMetadata();
  }

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
    if (widget.onToggle != null) {
      widget.onToggle!(value);
      return;
    }

    value ? _amplitudeVibrationService.resumeVibrating() : _amplitudeVibrationService.pauseVibrating();
  }
}
