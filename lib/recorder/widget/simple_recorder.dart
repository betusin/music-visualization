import 'package:flutter/material.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';
import 'package:vibration_poc/recorder/service/recorder_controller.dart';
import 'package:vibration_poc/vibration/service/amplitude_vibration_service.dart';

class SimpleRecorder extends StatelessWidget {
  final _recorderController = get<RecorderController>();
  final _amplitudeVibrationService = get<AmplitudeVibrationService>();

  SimpleRecorder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () => _startRecordingToStream(context), child: Text('start recording')),
            SizedBox(width: 8),
            ElevatedButton(onPressed: () => _recorderController.stopRecording(), child: Text('stop recording')),
          ],
        ),
        ElevatedButton(
          onPressed: () => _amplitudeVibrationService.vibrateBasedOnAmplitudeFromMicrophone(),
          child: Text('start vibrating based on input'),
        ),
      ],
    );
  }

  Future<void> _startRecordingToStream(BuildContext context) async {
    if (await _recorderController.hasPermission()) {
      _recorderController.startRecording();
      return;
    }
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text('No permissions')),
      );
    }
  }
}
