import 'package:flutter/material.dart';
import 'package:ui_kit/stream/widget/handling_stream_builder.dart';
import 'package:vibration_poc/background_service/widget/start_stop_buttons.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';
import 'package:vibration_poc/recorder/service/recorder_controller.dart';

class SimpleRecorder extends StatelessWidget {
  final _recorderController = get<RecorderController>();

  SimpleRecorder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStartStopRecording(context),
        StartStopButtons(),
      ],
    );
  }

  Widget _buildStartStopRecording(BuildContext context) {
    return HandlingStreamBuilder(
      stream: _recorderController.stream,
      builder: (context, data) {
        final isRecording = data != null;
        return ElevatedButton.icon(
          onPressed: () => isRecording ? _recorderController.stopRecording() : _startRecordingToStream(context),
          icon: Icon(isRecording ? Icons.mic_off_rounded : Icons.mic_rounded),
          label: Text('${isRecording ? 'Stop' : 'Start'} recording'),
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
