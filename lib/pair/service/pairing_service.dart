import 'package:vibration_poc/auth/service/auth_service.dart';

class PairingService {
  final AuthService _authService;

  const PairingService(this._authService);

  void createPairingDoc() {
    // TODO(betka): implement this
    final currentUser = _authService.currentUser;
    print(currentUser?.uid);
  }
}
