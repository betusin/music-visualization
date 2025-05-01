import 'package:rxdart/rxdart.dart';
import 'package:vibration_poc/vibration/service/data_amplitude_vibration_service.dart';

class TestModeController {
  final DataAmplitudeVibrationService _dataAmplitudeVibrationService;

  TestModeController(this._dataAmplitudeVibrationService);

  final _testModeOnController = BehaviorSubject<bool>.seeded(true);
  late final testModeOnStream = _testModeOnController.stream;

  void finishTestMode() {
    _testModeOnController.add(false);
    _dataAmplitudeVibrationService.stopStreamingVibrationMetadata();
  }
}
