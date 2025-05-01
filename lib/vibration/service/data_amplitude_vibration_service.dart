import 'dart:async';

import 'package:firebase_kit/collection_repo/firestore_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:vibration_poc/auth/service/auth_service.dart';
import 'package:vibration_poc/vibration/model/vibration_metadata.dart';
import 'package:vibration_poc/vibration/service/amplitude_vibration_service.dart';

class DataAmplitudeVibrationService implements Disposable {
  final AmplitudeVibrationService _amplitudeVibrationService;
  final FirestoreRepository<VibrationMetadata> _vibrationMetadataRepo;
  final AuthService _authService;

  DataAmplitudeVibrationService(this._amplitudeVibrationService, this._vibrationMetadataRepo, this._authService);

  StreamSubscription? _vibrationSubscription;

  void vibrateBasedOnCurrentUser() {
    final uid = _authService.currentUser?.uid;
    if (uid == null) {
      return;
    }
    vibrateBasedOnDeviceId(uid);
  }

  void vibrateBasedOnDeviceId(String deviceId) {
    assert(_vibrationSubscription == null, 'Cannot start two parallel vibrations for multiple devices.');
    if (_vibrationSubscription != null) {
      stopStreamingVibrationMetadata();
    }

    _vibrationSubscription = _vibrationMetadataRepo.observeDocument(deviceId).listen((vibrationMetadata) {
      vibrationMetadata == null
          ? _amplitudeVibrationService.stopVibrating()
          : _amplitudeVibrationService.vibrateBasedOnVibrationMetadata(vibrationMetadata);
    });
  }

  Future<void> stopStreamingVibrationMetadata() async {
    await _vibrationSubscription?.cancel();
    _vibrationSubscription = null;
    _amplitudeVibrationService.stopVibrating();
  }

  @override
  Future onDispose() async {
    await _dispose();
  }

  Future<void> _dispose() async {
    await _vibrationSubscription?.cancel();
    _vibrationSubscription = null;
  }
}
