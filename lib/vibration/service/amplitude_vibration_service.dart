import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration_poc/recorder/service/recorder_controller.dart';
import 'package:vibration_poc/vibration/util/amplitude_constants.dart';

// TODO(betka): the normalization factor was just guessed
const _amplitudeNormalizationFactor = 32;

class AmplitudeVibrationService implements Disposable {
  final RecorderController _recorderController;
  StreamSubscription? _amplitudeSubscription;

  AmplitudeVibrationService(this._recorderController);

  Future<void> vibrateBasedOnAmplitudeFromMicrophone() async {
    _amplitudeSubscription = _recorderController.getAmplitudePeriodicStream().listen(
      (futureAmplitude) async {
        final amplitudeData = await futureAmplitude;
        Vibration.cancel();
        if (amplitudeData != null) {
          final normalizedAmplitude = amplitudeData.current + _amplitudeNormalizationFactor;
          final constrainedAmplitude = normalizedAmplitude.clamp(minAmplitude, maxAmplitude);
          Vibration.vibrate(amplitude: constrainedAmplitude.toInt());
        }
      },
    );
  }

  Future<void> stopVibrating() async {
    Vibration.cancel();
    await _amplitudeSubscription?.cancel();
    _amplitudeSubscription = null;
  }

  @override
  Future onDispose() async {
    await _amplitudeSubscription?.cancel();
  }
}
