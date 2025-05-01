import 'package:firebase_kit/collection_repo/firestore_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:vibration_poc/auth/service/auth_service.dart';
import 'package:vibration_poc/background_service/service/background_service_handler.dart';
import 'package:vibration_poc/common/collection_names.dart';
import 'package:vibration_poc/pair/model/pair_link.dart';
import 'package:vibration_poc/pair/model/pair_request.dart';
import 'package:vibration_poc/pair/service/pairing_service.dart';
import 'package:vibration_poc/recorder/service/recorder_controller.dart';
import 'package:vibration_poc/song_picking_test/service/test_mode_controller.dart';
import 'package:vibration_poc/storage/serivce/firebase_storage_service.dart';
import 'package:vibration_poc/vibration/model/vibration_metadata.dart';
import 'package:vibration_poc/vibration/service/amplitude_vibration_service.dart';
import 'package:vibration_poc/vibration/service/data_amplitude_vibration_service.dart';

final get = GetIt.instance;

class IocContainer {
  IocContainer._();

  static void backgroundSetup() {
    get.registerSingleton(RecorderController());
    get.registerSingleton(AmplitudeVibrationService(
      get<RecorderController>(),
    ));
  }

  static void setup() {
    get.registerSingleton(FirestoreRepository<PairRequest>(
      CollectionNames.pairRequestsCollection,
      (json) => PairRequest.fromJson(json),
    ));
    get.registerSingleton(FirestoreRepository<PairLink>(
      CollectionNames.pairLinksCollection,
      (json) => PairLink.fromJson(json),
    ));
    get.registerSingleton(FirestoreRepository<VibrationMetadata>(
      CollectionNames.vibrationMetadataCollection,
      (json) => VibrationMetadata.fromJson(json),
    ));

    get.registerSingleton(AuthService());
    get.registerSingleton(PairingService(
      get<AuthService>(),
      get<FirestoreRepository<PairRequest>>(),
      get<FirestoreRepository<PairLink>>(),
    ));

    get.registerSingleton(RecorderController());
    get.registerSingleton(BackgroundServiceHandler(get<RecorderController>()));
    get.registerSingleton(AmplitudeVibrationService(
      get<RecorderController>(),
    ));
    get.registerSingleton(FirebaseStorageService());
    get.registerSingleton(DataAmplitudeVibrationService(
      get<AmplitudeVibrationService>(),
      get<FirestoreRepository<VibrationMetadata>>(),
      get<AuthService>(),
    ));
    get.registerSingleton(TestModeController(
      get<DataAmplitudeVibrationService>(),
    ));
  }
}
