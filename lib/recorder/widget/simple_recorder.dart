import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';
import 'package:vibration_poc/recorder/service/recorder_controller.dart';

class SimpleRecorder extends StatelessWidget {
  final _recorderController = get<RecorderController>();
  SimpleRecorder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(onPressed: () => _startRecordingToStream(context), child: Text('start recording')),
        ElevatedButton(onPressed: () => _recorderController.stopRecording(), child: Text('stop recording')),
        _buildAudioProgress(),
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

  Widget _buildAudioProgress() {
    return StreamBuilder(
      stream: _recorderController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildAmplitude();
        }
        return Text('No recording in progress');
      },
    );
  }

  Widget _buildAmplitude() {
    return FutureBuilder(
      future: _recorderController.getCurrentNormalizedAmplitude(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // TODO(betka): this does not need to be in FutureBuilder, move to service,
          //  which will inject RecordController and vibrate based on the stream
          final amplitude = snapshot.data!;
          Vibration.cancel();
          Vibration.vibrate(amplitude: amplitude.clamp(minAmplitudeValue, maxAmplitudeValue).toInt());
          return Text('normalized amplitude $amplitude');
        }
        return CircularProgressIndicator();
      },
    );
  }
}
