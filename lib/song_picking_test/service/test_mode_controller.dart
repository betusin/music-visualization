import 'package:rxdart/rxdart.dart';

class TestModeController {
  final _testModeOnController = BehaviorSubject<bool>.seeded(true);
  late final testModeOnStream = _testModeOnController.stream;

  void finishTestMode() => _testModeOnController.add(false);
  // TODO(betka): maybe not needed in future - can be removed
  void startTestMode() => _testModeOnController.add(true);
}
