import 'package:flutter/material.dart';
import 'package:ui_kit/stream/widget/handling_stream_builder.dart';
import 'package:vibration_poc/background_service/widget/on_off_background_buttons.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';
import 'package:vibration_poc/recorder/service/recorder_controller.dart';
import 'package:vibration_poc/vibration/service/amplitude_vibration_service.dart';

class SimpleRecorder extends StatelessWidget {
  final _recorderController = get<RecorderController>();
  final _vibrationService = get<AmplitudeVibrationService>();

  SimpleRecorder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStartStopRecording(context),
        OnOffBackgroundButtons(),
      ],
    );
  }

  Widget _buildStartStopRecording(BuildContext context) {
    return HandlingStreamBuilder(
      stream: _recorderController.stream,
      builder: (context, data) {
        final isRecording = data != null;
        return ElevatedButton.icon(
          onPressed: () => isRecording ? _stopRecording() : _startRecordingToStream(context),
          icon: Icon(isRecording ? Icons.mic_off_rounded : Icons.mic_rounded),
          label: Text('${isRecording ? 'Stop' : 'Start'} recording'),
        );
      },
    );
  }

  void _stopRecording() {
    _vibrationService.stopVibrating();
    _recorderController.stopRecording();
  }

  Future<void> _startRecordingToStream(BuildContext context) async {
    if (await _recorderController.hasPermission()) {
      _recorderController.startRecording();
      _vibrationService.vibrateBasedOnAmplitudeFromMicrophone();
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
