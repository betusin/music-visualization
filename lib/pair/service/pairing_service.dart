import 'dart:io';
import 'dart:math';

import 'package:database_kit/collection_read/model/abstract_filter_parameter.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_kit/collection_repo/firestore_repository.dart';
import 'package:master_kit/util/random_id_generator.dart';
import 'package:vibration_poc/auth/service/auth_service.dart';
import 'package:vibration_poc/pair/enum/pair_request_status.dart';
import 'package:vibration_poc/pair/model/pair_link.dart';
import 'package:vibration_poc/pair/model/pair_request.dart';

class PairingService {
  final AuthService _authService;
  final FirestoreRepository<PairRequest> _pairRequestsRepository;
  final FirestoreRepository<PairLink> _pairLinksRepository;

  const PairingService(this._authService, this._pairRequestsRepository, this._pairLinksRepository);

  Stream<List<PairRequest>> get currentRequests {
    final uid = _authService.currentUser?.uid;
    if (uid == null) {
      return Stream.empty();
    }

    final yesterday = DateTime.now().subtract(Duration(days: 1));

    return _pairRequestsRepository.observeDocs(
      filters: [
        FilterParameter(PairRequest.deviceIdKey, isEqualTo: uid),
        FilterParameter(PairRequest.timestampKey, isGreaterThanOrEqualTo: yesterday),
      ],
    );
  }

  Stream<List<PairRequest>> requestsByCodeStream(int code) {
    return _pairRequestsRepository.observeDocs(filters: [FilterParameter(PairRequest.codeKey, isEqualTo: code)]);
  }

  Stream<List<PairLink>> get getPairLinksPerCurrentWatch {
    final uid = _authService.currentUser?.uid;
    if (uid == null) {
      return Stream.empty();
    }

    return _pairLinksRepository.observeDocs(
      filters: [FilterParameter(PairLink.watchIdKey, isEqualTo: uid)],
    );
  }

  Future<void> createPairingDoc() async {
    final currentUser = _authService.currentUser;

    if (currentUser == null) {
      // TODO(betka): better error handling?
      return;
    }

    // TODO(betka): delete all pending requests from this user?

    final id = generateRandomString();
    final pairRequest =
        PairRequest(id: id, code: _generateSixDigitCode(), deviceId: currentUser.uid, createdAt: DateTime.now());
    _pairRequestsRepository.createOrReplace(pairRequest, id);
  }

  void updatePairRequestStatus(String id, PairRequestStatus status) {
    _pairRequestsRepository.mergeIn(id, {PairRequest.statusKey: status.value});
  }

  void updatePairRequestToWait(String id) {
    final currentUser = _authService.currentUser;

    if (currentUser == null) {
      // TODO(betka): better error handling?
      return;
    }

    _pairRequestsRepository.mergeIn(id, {
      PairRequest.statusKey: PairRequestStatus.waitingForConfirmation.value,
      PairRequest.watchIdKey: currentUser.uid,
    });
  }

  Future<void> pairDevices(String watchId) async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      // TODO(betka): better error handling?
      return;
    }

    final id = generateRandomString();

    final deviceName = await _getDeviceName();

    final link = PairLink(
      id: id,
      deviceId: currentUser.uid,
      deviceName: deviceName,
      watchId: watchId,
      createdAt: DateTime.now(),
    );
    _pairLinksRepository.createOrReplace(link, id);
  }

  // TODO(betka): could be method in separate service
  Future<String> _getDeviceName() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final deviceInfo = await deviceInfoPlugin.androidInfo;
      return deviceInfo.model;
    }
    if (Platform.isIOS) {
      final deviceInfo = await deviceInfoPlugin.iosInfo;
      return deviceInfo.model;
    }

    throw UnsupportedError('Not supported on other than iOS or Android');
  }

  void unpairDevices(String pairLinkId) => _pairLinksRepository.delete(pairLinkId);

  Future<PairRequest?> getPairRequestByCode(int code) async {
    final docs = await _pairRequestsRepository.getDocuments(
      filters: [FilterParameter(PairRequest.codeKey, isEqualTo: code)],
    );
    return docs.firstOrNull;
  }

  int _generateSixDigitCode() => 100000 + Random().nextInt(900000);
}
