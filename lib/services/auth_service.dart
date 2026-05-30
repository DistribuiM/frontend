import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:google_sign_in/google_sign_in.dart';

import '../config/app_config.dart';

class AuthService {
  String getGoogleSignInClientId() {
    if (kIsWeb) {
      return AppConfig.webClientId;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AppConfig.androidClientId;

      case TargetPlatform.iOS:
        return AppConfig.iosClientId;

      default:
        throw UnsupportedError(
          'Google Sign-In not supported on this platform',
        );
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      // WEB
      if (kIsWeb) {
        return await FirebaseAuth.instance.signInWithPopup(
          GoogleAuthProvider(),
        );
      }

      // MOBILE
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize(
        clientId: getGoogleSignInClientId(),
        serverClientId: AppConfig.webClientId
      );

      final GoogleSignInAccount googleUser =
          await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      final OAuthCredential credential =
          GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance
          .signInWithCredential(credential);
    } catch (e) {
      throw Exception(
        'Erro ao fazer login com Google: $e',
      );
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn.instance.signOut();
  }
}