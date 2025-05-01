import 'dart:async';
import 'dart:math';

import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration_poc/recorder/service/recorder_controller.dart';
import 'package:vibration_poc/vibration/model/vibration_metadata.dart';
import 'package:vibration_poc/vibration/model/vibration_status_enum.dart';
import 'package:vibration_poc/vibration/util/amplitude_constants.dart';
import 'package:vibration_poc/vibration/util/amplitude_converter.dart';

// TODO(betka): the normalization factor was just guessed
const _defaultAmplitudeNormalizationFactor = 0.0;

class AmplitudeVibrationService implements Disposable {
  final RecorderController _recorderController;

  final _vibrationController = BehaviorSubject<bool>.seeded(false);
  final _amplitudeController = BehaviorSubject<double>.seeded(_defaultAmplitudeNormalizationFactor);

  StreamSubscription? _amplitudeSubscription;

  AmplitudeVibrationService(this._recorderController);

  Stream<bool> get vibrationOnStream => _vibrationController.stream;
  Stream<double> get amplitudeStream => _amplitudeController.stream;

  Future<void> vibrateBasedOnAmplitudeFromMicrophone() async {
    _vibrationController.add(true);

    _amplitudeSubscription = _recorderController.getAmplitudePeriodicStream().listen(
      (futureAmplitude) async {
        final amplitudeData = await futureAmplitude;
        _vibrateBasedOnAmplitude(amplitudeData?.current);
      },
    );
  }

  void _vibrateBasedOnAmplitude(double? amplitude) {
    Vibration.cancel();
    if (amplitude != null) {
      final normalizedAmplitude = max(amplitude + _amplitudeController.value, minDbFS);
      final constrainedAmplitude = AmplitudeConverter.mapDbFsToVibrationAmplitude(normalizedAmplitude);
      Vibration.vibrate(amplitude: constrainedAmplitude.toInt());
    }
  }

  Future<void> vibrateBasedOnVibrationMetadata(VibrationMetadata vibrationMetadata) async {
    _vibrationController.add(true);

    for (final amplitude in vibrationMetadata.amplitudes) {
      if (vibrationMetadata.vibrationStatus == VibrationStatus.playing) {
        if (_vibrationController.value) {
          _vibrateBasedOnAmplitude(amplitude);
        }
        await Future.delayed(Duration(milliseconds: vibrationMetadata.beat));
      } else {
        stopVibrating();
        return;
      }
    }

    stopVibrating();
  }

  void setAmplitude(double value) => _amplitudeController.add(value);

  void resumeVibrating() => _vibrationController.add(true);
  void pauseVibrating() => _vibrationController.add(false);

  Future<void> stopVibrating() async {
    Vibration.cancel();
    await _amplitudeSubscription?.cancel();
    _amplitudeSubscription = null;
    _vibrationController.add(false);
  }

  @override
  Future onDispose() async {
    await _amplitudeSubscription?.cancel();
  }
}
