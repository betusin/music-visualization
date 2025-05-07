import 'dart:async';
import 'dart:ui';

import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration_poc/recorder/service/recorder_controller.dart';
import 'package:vibration_poc/vibration/model/vibration_metadata.dart';
import 'package:vibration_poc/vibration/model/vibration_status_enum.dart';
import 'package:vibration_poc/vibration/util/amplitude_constants.dart';
import 'package:vibration_poc/vibration/util/amplitude_converter.dart';

const _defaultAmplitudeNormalizationFactor = 0.0;

class AmplitudeVibrationService implements Disposable {
  final RecorderController _recorderController;

  final _vibrationController = BehaviorSubject<bool>.seeded(true);
  final _amplitudeController = BehaviorSubject<double>.seeded(_defaultAmplitudeNormalizationFactor);

  StreamSubscription? _amplitudeSubscription;
  bool _manuallyStopped = false;

  AmplitudeVibrationService(this._recorderController);

  Stream<bool> get vibrationOnStream => _vibrationController.stream;
  Stream<double> get amplitudeStream => _amplitudeController.stream;
  bool get _canVibrate => _vibrationController.value;

  Future<void> vibrateBasedOnAmplitudeFromMicrophone() async {
    _manuallyStart();

    _amplitudeSubscription = _recorderController.getAmplitudePeriodicStream().listen(
      (futureAmplitude) async {
        final amplitudeData = await futureAmplitude;
        final constrainedAmplitude = AmplitudeConverter.mapDbFsToVibrationAmplitude(amplitudeData?.current ?? 0);
        _vibrateBasedOnAmplitude(constrainedAmplitude.toDouble());
      },
    );
  }

  void _vibrateBasedOnAmplitude(double? amplitude) {
    Vibration.cancel();
    if (amplitude != null && _canVibrate && amplitude > 0) {
      final normalizedAmplitude = clampDouble(amplitude, minAmplitude, maxAmplitude);
      Vibration.vibrate(amplitude: normalizedAmplitude.toInt());
    }
  }

  Future<void> vibrateBasedOnVibrationMetadata(VibrationMetadata vibrationMetadata) async {
    _manuallyStart();

    final now = DateTime.now();
    final delayedStart = vibrationMetadata.startAt.difference(now);
    await Future.delayed(delayedStart);

    for (final amplitude in vibrationMetadata.amplitudes) {
      if (vibrationMetadata.vibrationStatus == VibrationStatus.playing && !_manuallyStopped) {
        _vibrateBasedOnAmplitude(amplitude);
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

  void _manuallyStop() => _manuallyStopped = true;
  void _manuallyStart() => _manuallyStopped = false;

  Future<void> stopVibrating() async {
    Vibration.cancel();
    await _amplitudeSubscription?.cancel();
    _amplitudeSubscription = null;
    _manuallyStop();
  }

  @override
  Future onDispose() async {
    await _amplitudeSubscription?.cancel();
  }
}
