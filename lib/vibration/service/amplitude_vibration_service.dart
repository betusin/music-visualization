import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration_poc/recorder/service/recorder_controller.dart';
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
        Vibration.cancel();
        if (amplitudeData != null) {
          final normalizedAmplitude = amplitudeData.current + _amplitudeController.value;
          final constrainedAmplitude = AmplitudeConverter.mapDbFsToVibrationAmplitude(normalizedAmplitude);
          Vibration.vibrate(amplitude: constrainedAmplitude.toInt());
        }
      },
    );
  }

  void setAmplitude(double value) => _amplitudeController.add(value);

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
