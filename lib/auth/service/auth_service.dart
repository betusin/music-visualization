import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  void signInAnonymously() {
    _firebaseAuth.signInAnonymously();
  }
}
