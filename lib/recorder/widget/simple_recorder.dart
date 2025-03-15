import 'package:flutter/material.dart';
import 'package:ui_kit/stream/widget/handling_stream_builder.dart';
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

  Widget _buildStartStopRecording(BuildContext context) {
    return HandlingStreamBuilder(
      stream: _recorderController.stream,
      builder: (context, data) {
        if (data == null) {
          return ElevatedButton.icon(
            onPressed: () => _startRecordingToStream(context),
            icon: Icon(Icons.play_arrow),
            label: Text('Play'),
          );
        }
        return ElevatedButton.icon(
          onPressed: () => _recorderController.stopRecording(),
          icon: Icon(Icons.pause),
          label: Text('Pause'),
        );
      },
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
