import 'package:flutter/material.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';
import 'package:vibration_poc/recorder/service/recorder_controller.dart';
import 'package:vibration_poc/vibration/widget/vibration_switcher_and_adjuster.dart';

class SimpleRecorder extends StatelessWidget {
  final _recorderController = get<RecorderController>();

  SimpleRecorder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStartStopRecording(context),
        VibrationSwitcherAndAdjuster(),
      ],
    );
  }

  Row _buildStartStopRecording(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(onPressed: () => _startRecordingToStream(context), child: Text('start recording')),
        SizedBox(width: 8),
        ElevatedButton(onPressed: () => _recorderController.stopRecording(), child: Text('stop recording')),
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
