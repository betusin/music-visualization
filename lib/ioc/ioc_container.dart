import 'package:get_it/get_it.dart';
import 'package:vibration_poc/background_service/service/background_service_handler.dart';
import 'package:vibration_poc/recorder/service/recorder_controller.dart';
import 'package:vibration_poc/vibration/service/amplitude_vibration_service.dart';

final get = GetIt.instance;

class IocContainer {
  IocContainer._();

  static void setup() {
    get.registerSingleton(RecorderController());
    get.registerSingleton(BackgroundServiceHandler(get<RecorderController>()));
    get.registerSingleton(AmplitudeVibrationService(get<RecorderController>()));
  }
}
