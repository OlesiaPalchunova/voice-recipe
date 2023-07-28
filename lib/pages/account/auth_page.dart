import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voice_recipe/pages/account/login_page.dart';
import 'package:voice_recipe/pages/account/profile_page.dart';

import '../../model/profile.dart';
import '../../services/auth/Token.dart';
import '../../services/db/profile_db.dart';

class AuthPage extends StatelessWidget{
  const AuthPage({super.key});

  static const route = '/profile';

  static Profile profile = Profile(uid: "", display_name: "", image: "", info: "", tg_link: "", vk_link: "");

  Future getInfo() async{
    profile = await ProfileDB().getProfile();
    print("gggggggggggggggggggggg");
    print(profile.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Stream.fromFuture(Token.getAccessToken()),
        builder: (context, snapshot) {
          if (snapshot.data != "000") {
            getInfo();
            print("llllllllllllllllllllllllllllllllll");
            return AccountPage(profile: profile,);
          }
          return const LoginPage();
        },
      ),
    );
  }
}
