import 'dart:async';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:record/record.dart';
import 'package:rxdart/rxdart.dart';

const _amplitudeNormalizationFactor = 29;

class RecorderController implements Disposable {
  final _recorder = AudioRecorder();
  final _streamController = BehaviorSubject<Uint8List?>.seeded(null);
  StreamSubscription<Uint8List>? _streamSubscription;

  Stream<Uint8List?> get stream => _streamController.stream;

  Future<bool> hasPermission() async => await _recorder.hasPermission();

  Future<void> startRecording() async {
    if (await hasPermission()) {
      final recordingStream = await _recorder.startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits));
      _streamSubscription = recordingStream.listen((event) => _streamController.add(event));
    }
  }

  Future<void> stopRecording() async {
    await _recorder.stop();
    _streamController.add(null);
    _streamSubscription?.cancel();
  }

  Future<Amplitude> getAmplitude() async => await _recorder.getAmplitude();

  Future<double> getCurrentNormalizedAmplitude() async {
    final amplitude = await _recorder.getAmplitude();
    // TODO(betka): find out a better normalization
    final normalizedCurrentAmplitude = amplitude.current + _amplitudeNormalizationFactor;
    return normalizedCurrentAmplitude;
  }

  @override
  void onDispose() {
    _streamController.close();
    _streamSubscription?.cancel();
  }
}
