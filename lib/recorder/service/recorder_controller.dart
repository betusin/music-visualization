import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:record/record.dart';
import 'package:rxdart/rxdart.dart';

class RecorderController implements Disposable {
  final _recorder = AudioRecorder();
  final _streamController = BehaviorSubject<Uint8List?>.seeded(null);

  Stream<Uint8List?> get stream => _streamController.stream;

  Future<bool> hasPermission() async => await _recorder.hasPermission();

  Future<void> startRecording() async {
    if (await hasPermission()) {
      final recordingStream = await _recorder.startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits));
      // TODO(betka): close subscription
      recordingStream.listen((event) => _streamController.add(event));
    }
  }

  Future<void> stopRecording() async {
    await _recorder.stop();
    _streamController.add(null);
  }

  Future<Amplitude> getAmplitude() async => await _recorder.getAmplitude();

  @override
  void onDispose() {
    _streamController.close();
  }
}
