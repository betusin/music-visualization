import 'dart:math';

import 'package:firebase_kit/collection_repo/firestore_repository.dart';
import 'package:vibration_poc/auth/service/auth_service.dart';
import 'package:vibration_poc/pair/model/pair_data.dart';

class PairingService {
  final AuthService _authService;
  final FirestoreRepository<PairData> _pairRepository;

  const PairingService(this._authService, this._pairRepository);

  Stream<PairData?> get currentPairingData {
    final uid = _authService.currentUser?.uid;
    return uid == null ? Stream.value(null) : _pairRepository.observeDocument(uid);
  }

  Future<void> createPairingDoc() async {
    final currentUser = _authService.currentUser;

    if (currentUser == null) {
      // TODO(betka): better error handling?
      return;
    }

    final uid = currentUser.uid;
    final docExists = await _pairRepository.documentExists(uid);

    if (!docExists) {
      final pairData = PairData(id: uid, pairCode: _generateSixDigitCode(), deviceId: '', createdAt: DateTime.now());
      _pairRepository.createOrReplace(pairData, uid);
    }
  }

  int _generateSixDigitCode() => 100000 + Random().nextInt(900000);
}
