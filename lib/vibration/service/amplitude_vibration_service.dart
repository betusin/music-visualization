import 'package:vibration/vibration.dart';
import 'package:vibration_poc/recorder/service/recorder_controller.dart';

// TODO(betka): the normalization factor was just guessed
const _amplitudeNormalizationFactor = 32;

class AmplitudeVibrationService {
  final RecorderController _recorderController;

  const AmplitudeVibrationService(this._recorderController);

  Future<void> vibrateBasedOnAmplitudeFromMicrophone() async {
    await for (final future in _recorderController.getAmplitudePeriodicStream()) {
      final amplitudeData = await future;
      Vibration.cancel();
      if (amplitudeData != null) {
        final normalizedAmplitude = amplitudeData.current + _amplitudeNormalizationFactor;
        final constrainedAmplitude = normalizedAmplitude.clamp(minAmplitudeValue, maxAmplitudeValue);
        Vibration.vibrate(amplitude: constrainedAmplitude.toInt());
      }
    }
  }

  // TODO(betka): implement
  void stopVibrating() {
    throw UnimplementedError();
  }
}
