import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:voice_recipe/pages/collections/future_collection_page.dart';
import 'package:voice_recipe/sidebar_menu/side_bar_tile.dart';

import 'package:voice_recipe/config.dart';
import 'package:voice_recipe/pages/constructor/create_recipe_page.dart';
import 'package:voice_recipe/pages/account/login_page.dart';
import 'package:voice_recipe/pages/collections/collections_list_page.dart';

import 'package:voice_recipe/model/users_info.dart';
import 'package:voice_recipe/pages/account/auth_page.dart';

class SideBarMenu extends StatefulWidget {
  const SideBarMenu({super.key});

  @override
  State<SideBarMenu> createState() => _SideBarMenuState();

  static double nameFontSize(BuildContext context) =>
      Config.isDesktop(context) ? 16 : 14;

  static double fontSize(BuildContext context) =>
      Config.isDesktop(context) ? 18 : 14;

  static double radius(BuildContext context) =>
      Config.isDesktop(context) ? 22 : 20;
}

class _SideBarMenuState extends State<SideBarMenu> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: min(Config.pageWidth(context) * 0.7, 400),
      child: Material(
          color: Config.darkModeOn ? Config.backgroundColor : Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(Config.padding),
                child: Column(
                  children: [
                    SizedBox(
                      height: Config.pageHeight(context) / 7,
                    ),
                    buildProfileLabel(),
                    SideBarTile(
                        name: "Подборки",
                        onClicked: () =>
                            Routemaster.of(context).push(CollectionsListPage.route),
                        iconData: Config.darkModeOn
                            ? Icons.library_books_outlined
                            : Icons.library_books_outlined),
                    Config.isWeb ? SideBarTile(
                        name: "Создать рецепт",
                        onClicked: () {
                          Routemaster.of(context).push(CreateRecipePage.route);
                        },
                        iconData: Config.darkModeOn
                            ? Icons.create_outlined
                            : Icons.create_outlined) : Container(),
                    SideBarTile(
                        name: "Голосовые команды",
                        onClicked: () {
                          Config.showAlertDialog(
                              "В стадии разработки", context);
                        },
                        iconData: Config.darkModeOn
                            ? Icons.record_voice_over_outlined
                            : Icons.record_voice_over_outlined),
                    SideBarTile(
                        name: "Понравившиеся",
                        onClicked: () async {
                          if (!Config.loggedIn) {
                            Config.showLoginInviteDialog(context);
                            return;
                          }
                          Routemaster.of(context).push('${FutureCollectionPage.route}favorites');
                        },
                        iconData: Config.darkModeOn
                            ? Icons.thumb_up_alt_outlined
                            : Icons.thumb_up_alt_outlined),
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
                          fontSize: SideBarMenu.fontSize(context)),
                    ),
                    CupertinoSwitch(
                      value: Config.darkModeOn,
                      onChanged: (value) {
                        setState(() {
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

  Widget buildProfile(User user) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Routemaster.of(context).push(AuthPage.route);
          },
          borderRadius: Config.borderRadiusLarge,
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
                    borderRadius:
                    BorderRadius.circular(SideBarMenu.radius(context)),
                    child: Image.network(user.photoURL ?? defaultProfileUrl),
                  ),
                ),
              ),
              const SizedBox(width: Config.margin),
              Text(
                "${user.displayName}",
                style: TextStyle(
                  fontSize: SideBarMenu.nameFontSize(context),
                  color: Config.iconColor,
                  fontFamily: Config.fontFamily,
                ),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 0.2,
          color: Config.iconColor.withOpacity(0.5),
        ),
        const SizedBox(
          height: Config.padding * 2,
        ),
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
            return SideBarTile(
                name: "Войти",
                onClicked: () {
                  Routemaster.of(context).push(LoginPage.route);
                },
                iconData: Icons.login);
          }
        });
  }
}
