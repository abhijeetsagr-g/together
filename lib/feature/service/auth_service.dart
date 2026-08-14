import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static const String _serverClientId =
      '918556011851-ic3e4sbh2f3j6kn0fgtlipkrb9mf3sld.apps.googleusercontent.com';

  Future<void>? _init;

  Future<void> _ensureInitialized() =>
      _init ??= googleSignIn.initialize(serverClientId: _serverClientId);

  User? get currentUser => firebaseAuth.currentUser;

  Future<UserCredential?> signIn() async {
    try {
      await _ensureInitialized();
      final googleUser = await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      return await firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
  }

  // getters
  Stream<User?> get authStateChange => firebaseAuth.authStateChanges();
}
