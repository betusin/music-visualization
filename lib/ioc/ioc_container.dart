import 'package:get_it/get_it.dart';
import 'package:vibration_poc/audio/service/audio_file_controller.dart';
import 'package:vibration_poc/background_service/service/background_service_handler.dart';
import 'package:vibration_poc/recorder/service/recorder_controller.dart';
import 'package:vibration_poc/storage/serivce/firebase_storage_service.dart';
import 'package:vibration_poc/vibration/service/amplitude_vibration_service.dart';

final get = GetIt.instance;

class IocContainer {
  IocContainer._();

  static void setup() {
    get.registerSingleton(RecorderController());
    get.registerSingleton(BackgroundServiceHandler(get<RecorderController>()));
    get.registerSingleton(AudioFileController());
    get.registerSingleton(AmplitudeVibrationService(
      get<RecorderController>(),
      get<AudioFileController>(),
    ));
    get.registerSingleton(FirebaseStorageService());
  }
}
