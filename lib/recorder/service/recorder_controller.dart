import 'dart:async';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:record/record.dart';
import 'package:rxdart/rxdart.dart';

const _amplitudeNormalizationFactor = 32;

// these values are just guessed based on few experiments
const minPossibleAmplitudeValue = -50;
const maxPossibleAmplitudeValue = 10;

class RecorderController implements Disposable {
  final _recorder = AudioRecorder();
  final _streamController = BehaviorSubject<Uint8List?>.seeded(null);
  StreamSubscription<Uint8List>? _streamSubscription;

  Future<bool> get isRecording => _recorder.isRecording();

  Stream<Uint8List?> get stream => _streamController.stream;

  Future<bool> hasPermission() async => await _recorder.hasPermission();

  Future<void> startRecording() async {
    // TODO(betka): return FailableResult based on which of the following did not succeed
    if (await hasPermission()) {
      startRecordingInBackground();
    }
  }

  /// Same as startRecording(), but does not check if has permission for using the microphone
  Future<void> startRecordingInBackground() async {
    if (!await isRecording) {
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

  Stream<Future<Amplitude>?> getAmplitudePeriodicStream() {
    final periodicStream = Stream.periodic(
      Duration(milliseconds: 200),
      (computationCount) => computationCount,
    );

    return Rx.combineLatest2(
      periodicStream,
      _streamController.stream,
      (_, audioBytes) => audioBytes == null ? null : getAmplitude(),
    );
  }

  @override
  void onDispose() {
    _streamController.close();
    _streamSubscription?.cancel();
  }
}
