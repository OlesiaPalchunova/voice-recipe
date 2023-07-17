import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_recipe/services/service_io.dart';

import '../../api/api_fields.dart';
import '../../config/config.dart';
import 'package:voice_recipe/services/db/user_db_manager.dart';
import 'package:voice_recipe/model/users_info.dart';
import 'package:http/http.dart' as http;

class AuthenticationManager {
  static const delayMillis = 2000;
  late SharedPreferences prefs;
  static String accessToken = "000";
  String refreshToken = "000";

  static Future<String> getAccessToken() async{
    return accessToken;
  }

  @override
  void initState() {
    // super.initState();
    initSharedPref();
  }

  void initSharedPref() async{
    prefs = await SharedPreferences.getInstance();
}

  factory AuthenticationManager() {
    return AuthenticationManager._internal();
  }

  AuthenticationManager._internal();

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

  Future<bool> signIn(BuildContext context, String nickname, String password) async {
    // var reqBody = {
      // "email":email,
    //   "login":nickname,
    //   "password":password,
    // };
    //
    // var response = await http.post(Uri.parse('${apiUrl}login'),
    //     headers: {"Content-Type": "application/json"},
    //     body: jsonEncode(reqBody)
    // );
    //
    // var jsonResponse = jsonDecode(response.body);
    //
    // print(response.statusCode);
    //
    // if(response.statusCode == 200) {
    //   var accessToken = jsonResponse['accessToken'];
    //   var refreshToken = jsonResponse['refreshToken'];
    //   prefs.setString('token', accessToken);
    //   print('heeeeeeey!!!');
    // } else {
    //   print('Error');
    // }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: nickname,
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
      String passwordAgain, String display_name, String login) async {
    if (password != passwordAgain) {
      Future.delayed(const Duration(milliseconds: delayMillis), () {
        ServiceIO.showAlertDialog("Пароли не совпадают", context);
      });
      return false;
    }
    var reqBody = {
      // "email":email,
      "login":login,
      "password":password,
      "display_name":display_name,
    };

    var response = await http.post(Uri.parse('${apiUrl}registration'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody)
    );

    var jsonResponse = jsonDecode(response.body);

    print(response.statusCode);
    print(response.body);
    print("66666666666666");

    if(response.statusCode == 200) {
      accessToken = jsonResponse['accessToken'];
      refreshToken = jsonResponse['refreshToken'];
      // prefs.setString('token', accessToken);
      print(accessToken);
      print('heeeeeeey!!!');
    } else {
      print('Error');
    }

    // try {
    //   String emailCurrent = email;
    //   String passCurrent = password;
    //   await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //       email: emailCurrent, password: passCurrent);
    //   await FirebaseAuth.instance.signInWithEmailAndPassword(
    //       email: emailCurrent, password: passCurrent);
    //   var user = FirebaseAuth.instance.currentUser!;
    //   user.updateDisplayName("$firstName $secondName");
    //   await FirebaseAuth.instance.signOut();
    //   await UserDbManager().addNewUserData(user.uid, "$firstName $secondName",
    //       user.photoURL ?? defaultProfileUrl);
    // } on FirebaseException catch (e) {
    //   Future.delayed(const Duration(milliseconds: delayMillis), () {
    //     ServiceIO.showAlertDialog(e.message!, context);
    //   });
    //   return false;
    // }
    return true;
  }

  Future<bool> passwordReset(BuildContext context, String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      await Future.microtask(() => ServiceIO.showAlertDialog(
          "Подтверждение отправлено вам на почту.", context));
      return true;
    } on FirebaseException catch (e) {
      ServiceIO.showAlertDialog(e.message ?? "Возникла ошибка", context);
      return false;
    }
  }
}
