import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:voice_recipe/model/auth/vk.dart';

import '../../config.dart';
import '../db/user_db_manager.dart';
import '../users_info.dart';

class AuthenticationManager {

  factory AuthenticationManager() {
    return AuthenticationManager._internal();
  }

  AuthenticationManager._internal();

  void signInVK() {
    Vk().signIn();
  }

  Future signInWithGoogle(BuildContext context) async {
    Config.showProgressCircle(context);
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
      await Future.microtask(() => Navigator.of(context).pop());
    } on FirebaseException catch(e) {
      Config.showAlertDialog(e.message!, context);
    }
    await Future.microtask(() => Navigator.of(context).pop());
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

  Future signIn(BuildContext context, String email, String password) async {
    Config.showProgressCircle(context);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password);
      await Future.microtask(() => Navigator.of(context).pop());
    } on FirebaseException catch (e) {
      Config.showAlertDialog(e.message!, context);
    }
    await Future.microtask(() => Navigator.of(context).pop());
  }

  Future signUp(BuildContext context, String email, String password,
      String passwordAgain, String firstName, String secondName) async {
    Config.showProgressCircle(context);
    if (password != passwordAgain) {
      Config.showAlertDialog("Пароли не совпадают", context);
      return;
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
      await Future.microtask(() => Navigator.of(context).pop());
    } on FirebaseException catch (e) {
      debugPrint(e.message);
      Config.showAlertDialog(e.message!, context);
    }
    await Future.microtask(() => Navigator.of(context).pop());
  }

  Future passwordReset(BuildContext context, String email) async {
    Config.showProgressCircle(context);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      await Future.microtask(() => Config.showAlertDialog(
          "Подтверждение отправлено вам на почту.", context));
    } on FirebaseException catch (e) {
      Config.showAlertDialog(e.message ?? "Возникла ошибка", context);
    }
    await Future.microtask(() => Navigator.of(context).pop());
  }
}
