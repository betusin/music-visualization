import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:record/record.dart';

class SimpleRecorder extends StatefulWidget {
  const SimpleRecorder({super.key});

  @override
  State<SimpleRecorder> createState() => _SimpleRecorderState();
}

class _SimpleRecorderState extends State<SimpleRecorder> {
  final _recorder = AudioRecorder();
  Stream<Uint8List>? _stream;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _startRecordingToStream(BuildContext context) async {
    if (await _recorder.hasPermission()) {
      final stream = await _recorder.startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits));
      setState(() => _stream = stream);
    } else {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(title: Text('No permissions')),
        );
      }
    }
  }

  Future<void> _stopRecordingToStream() async {
    _recorder.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(onPressed: () => _startRecordingToStream(context), child: Text('start recording')),
        ElevatedButton(onPressed: () => _stopRecordingToStream(), child: Text('stop recording')),
        _buildAudioProgress(),
      ],
    );
  }

  Widget _buildAudioProgress() {
    return StreamBuilder(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildAmplitude();
        }
        return Text('amplitude cannot be computed');
      },
    );
  }

  Widget _buildAmplitude() {
    return FutureBuilder(
      future: _recorder.getAmplitude(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final amplitude = snapshot.data!;
          // TODO(betka): vibrate based on the amplitude
          return Text('amplitude ${amplitude.current}');
        }
        return CircularProgressIndicator();
      },
    );
  }
}
