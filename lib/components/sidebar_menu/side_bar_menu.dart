import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:voice_recipe/config.dart';
import 'package:voice_recipe/screens/account_screen.dart';
import 'package:voice_recipe/screens/authorization/login_screen.dart';
import 'package:voice_recipe/screens/sets_list_screen.dart';

import '../../themes/theme_change_notification.dart';

class SideBarMenu extends StatefulWidget {
  const SideBarMenu({super.key, required this.onUpdate});
  final VoidCallback onUpdate;

  @override
  State<SideBarMenu> createState() => _SideBarMenuState();

  static Widget buildHeader({
    required String name,
    required VoidCallback onClicked,
    required IconData iconData
  }) => Column(
    children: [
      InkWell(
        onTap: onClicked,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Config.darkModeOn ? Colors.orangeAccent
                          : Colors.orangeAccent
                  )
              ),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Config.backgroundColor,
                child: Icon(
                  iconData,
                  color: Config.iconColor,
                  size: 26,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Text(
              name,
              style: TextStyle(fontSize: 20, color: Config.iconColor,
                fontFamily: Config.fontFamily,),
            ),
          ],
        ),
      ),
      Divider(
        color: Config.iconColor.withOpacity(0.5),
        thickness: 0.2,
      ),
    ],
  );
}

class _SideBarMenuState extends State<SideBarMenu> {

  Widget buildProfile(User user) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)
            => const AccountScreen()));
          },
          child: Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Config.backgroundColor,
                  child: Image.asset(user.photoURL??
                      "assets/images/profile.png"),
                ),
              ),
              const SizedBox(width: 20),
              Text(
                "${user.displayName}",
                style: TextStyle(fontSize: 18, color: Config.iconColor,
                  fontFamily: Config.fontFamily,),
              ),
            ],
          ),
        ),
        Divider(
          color: Config.iconColor.withOpacity(0.5),
        ),
        const SizedBox(height: Config.padding * 2,),
      ],
    );
  }

  Widget buildProfileLabel() {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return buildProfile(snapshot.data!);
          } else {
            return SideBarMenu.buildHeader(
                name: "Войти",
                onClicked: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>
                    const LoginScreen())
                  );
                },
                iconData: Icons.login
            );
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: min(Config.pageWidth(context) * 0.7, 400),
      child: Material(
          color: Config.backgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(Config.padding),
                child: Column(
                  children: [
                    SizedBox(height: Config.pageHeight(context) / 7,),
                    buildProfileLabel(),
                    SideBarMenu.buildHeader(
                      name: "Подборки",
                      onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SetsListScreen(),
                      )),
                      iconData: Config.darkModeOn ? Icons.library_books_rounded
                                                  : Icons.library_books_outlined
                    ),
                    SideBarMenu.buildHeader(
                        name: "Голосовые\nкоманды",
                        onClicked: () {
                        },
                        iconData: Config.darkModeOn ? Icons.record_voice_over_rounded
                            : Icons.record_voice_over_outlined
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(Config.margin, Config.margin,
                    Config.margin, Config.margin * 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Тёмная тема",
                      style: TextStyle(
                          fontFamily: Config.fontFamily,
                          color:
                              Config.darkModeOn ? Colors.white : Colors.black87,
                          fontSize: 16),
                    ),
                    CupertinoSwitch(
                      value: Config.darkModeOn,
                      onChanged: (value) {
                        setState(() {
                          widget.onUpdate();
                          Config.setDarkModeOn(!Config.darkModeOn);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
