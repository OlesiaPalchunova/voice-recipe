import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voice_recipe/components/appbars/title_logo_panel.dart';
import 'package:voice_recipe/components/login/button.dart';

import '../config.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TitleLogoPanel(title: "Аккаунт").appBar(),
      body: Container(
        alignment: Alignment.center,
        color: Config.backgroundColor,
        child: SizedBox(
          height: 60,
          child: Button(
            text: "Выйти из аккаунта",
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }
}
