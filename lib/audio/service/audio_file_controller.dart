import 'package:rxdart/rxdart.dart';
import 'package:vibration_poc/audio/service/audio_vibration_service.dart';

class AudioFileController {
  final AudioVibrationService _audioVibrationService;

  AudioFileController(this._audioVibrationService);

  final _audioAmplitudeController = BehaviorSubject<double?>.seeded(null);

  late final audioAmplitudeStream = _audioAmplitudeController.stream;

  Future<void> initVibrationStream(String filePath) async {
    final vibrationMetadata = await _audioVibrationService.convertAudioFileToVibration(filePath);

    if (vibrationMetadata == null) {
      // TODO(betka): better error handling

      return;
    }

    final delay = vibrationMetadata.beat;
    for (final amplitude in vibrationMetadata.amplitudes) {
      _audioAmplitudeController.add(amplitude);
      await Future.delayed(Duration(milliseconds: delay));
    }
  }
}
