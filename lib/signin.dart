import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Signin extends ChangeNotifier {
  final gSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;
  Future gLogin() async {
    final gUser = await gSignIn.signIn();
    if (gUser == null) return;
    _user = gUser;

    final gAuth = await gUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken, idToken: gAuth.idToken);

    await FirebaseAuth.instance.signInWithCredential(credential);
    notifyListeners();
  }

  Future logout() async {
    await gSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
