import 'package:get_it/get_it.dart';
import 'package:vibration_poc/recorder/service/recorder_controller.dart';

final get = GetIt.instance;

class IocContainer {
  IocContainer._();

  static void setup() {
    get.registerSingleton(RecorderController());
  }
}
