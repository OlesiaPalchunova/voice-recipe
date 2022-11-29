import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:voice_recipe/config.dart';
import 'package:voice_recipe/screens/profile_screen.dart';
import 'package:voice_recipe/screens/authorization/login_screen.dart';
import 'package:voice_recipe/screens/sets_list_screen.dart';

import '../../model/users_info.dart';

class SideBarMenu extends StatefulWidget {
  const SideBarMenu({super.key, required this.onUpdate});
  final VoidCallback onUpdate;

  @override
  State<SideBarMenu> createState() => _SideBarMenuState();

  static double nameFontSize(BuildContext context) => Config.isDesktop(context)
      ? 18 : 14;
  static double fontSize(BuildContext context) => Config.isDesktop(context)
      ? 18 : 16;
  static double radius(BuildContext context) => Config.isDesktop(context)
      ? 22 : 20;


  static Widget buildHeader({
    required BuildContext context,
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
                radius: radius(context),
                backgroundColor: Config.backgroundColor,
                child: Icon(
                  iconData,
                  color: Config.iconColor,
                  size: radius(context),
                ),
              ),
            ),
            const SizedBox(width: Config.margin * 2),
            Text(
              name,
              style: TextStyle(fontSize: fontSize(context), color: Config.iconColor,
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
                  radius: SideBarMenu.radius(context),
                  backgroundColor: Config.backgroundColor,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(SideBarMenu.radius(context)),
                    child: Image.network(user.photoURL??
                        defaultProfileUrl),
                  ),
                ),
              ),
              const SizedBox(width: Config.margin),
              Text(
                "${user.displayName}",
                style: TextStyle(fontSize: SideBarMenu.nameFontSize(context), color: Config.iconColor,
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
              context: context,
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
                        context: context,
                      name: "Подборки",
                      onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SetsListScreen(),
                      )),
                      iconData: Config.darkModeOn ? Icons.library_books_rounded
                                                  : Icons.library_books_outlined
                    ),
                    SideBarMenu.buildHeader(
                        context: context,
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
                          fontSize: SideBarMenu.fontSize(context)
                      ),
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
