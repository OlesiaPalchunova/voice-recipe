import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:voice_recipe/services/service_io.dart';

import '../../config/config.dart';
import '../db/user_db_manager.dart';
import '../users_info.dart';

class AuthenticationManager {
  static const delayMillis = 2000;

  factory AuthenticationManager() {
    return AuthenticationManager._internal();
  }

  AuthenticationManager._internal();

  void signInVK() {
    // Vk().signIn();
  }

  Future<bool> signInWithGoogle(BuildContext context) async {
    try {
      if (Config.isWeb) {
        await _signInWithGoogleWeb();
      } else {
        await _signInWithGoogleMobile();
      }
      var user = FirebaseAuth.instance.currentUser!;
      bool exists = await UserDbManager().containsUserData(user.uid);
      if (!exists) {
        UserDbManager().addNewUserData(user.uid,
            user.displayName?? "Пользователь",
            user.photoURL?? defaultProfileUrl
        );
      }
    } on FirebaseException catch(e) {
      Future.delayed(const Duration(milliseconds: delayMillis), () {
        ServiceIO.showAlertDialog(e.message!, context);
      });
      return false;
    }
    return true;
  }

  Future<UserCredential> _signInWithGoogleWeb() async {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();
    googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});
    return FirebaseAuth.instance.signInWithPopup(googleProvider);
  }

  Future<UserCredential> _signInWithGoogleMobile() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<bool> signIn(BuildContext context, String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password);
    } on FirebaseException catch (e) {
      Future.delayed(const Duration(milliseconds: delayMillis), () {
        ServiceIO.showAlertDialog(e.message!, context);
      });
      return false;
    }
    return true;
  }

  Future<bool> signUp(BuildContext context, String email, String password,
      String passwordAgain, String firstName, String secondName) async {
    if (password != passwordAgain) {
      Future.delayed(const Duration(milliseconds: delayMillis), () {
        ServiceIO.showAlertDialog("Пароли не совпадают", context);
      });
      return false;
    }
    try {
      String emailCurrent = email;
      String passCurrent = password;
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailCurrent, password: passCurrent);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailCurrent, password: passCurrent);
      var user = FirebaseAuth.instance.currentUser!;
      user.updateDisplayName("$firstName $secondName");
      await FirebaseAuth.instance.signOut();
      await UserDbManager().addNewUserData(user.uid, "$firstName $secondName",
          user.photoURL ?? defaultProfileUrl);
    } on FirebaseException catch (e) {
      Future.delayed(const Duration(milliseconds: delayMillis), () {
        ServiceIO.showAlertDialog(e.message!, context);
      });
      return false;
    }
    return true;
  }

  Future passwordReset(BuildContext context, String email) async {
    ServiceIO.showProgressCircle(context);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      await Future.microtask(() => ServiceIO.showAlertDialog(
          "Подтверждение отправлено вам на почту.", context));
    } on FirebaseException catch (e) {
      ServiceIO.showAlertDialog(e.message ?? "Возникла ошибка", context);
    }
    await Future.microtask(() => Navigator.of(context).pop());
  }
}
