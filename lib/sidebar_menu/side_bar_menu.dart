import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:voice_recipe/services/db/user_db.dart';
import 'package:voice_recipe/sidebar_menu/side_bar_tile.dart';

import 'package:voice_recipe/config/config.dart';
import 'package:voice_recipe/services/service_io.dart';
import 'package:voice_recipe/pages/constructor/create_recipe_page.dart';
import 'package:voice_recipe/pages/account/login_page.dart';
import 'package:voice_recipe/pages/collections/collections_list_page.dart';

import 'package:voice_recipe/model/users_info.dart';
import 'package:voice_recipe/pages/account/auth_page.dart';

import '../pages/user_page_template.dart';
import '../services/auth/Token.dart';

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
      width: min(Config.pageWidth(context) * .7, 400),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
            right: Radius.circular(Config.extraLargeRadius)),
      ),
      child: Material(
          borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(Config.extraLargeRadius)),
          color: Config.drawerColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(Config.padding),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 150,
                    ),
                    buildAccountOrLoginLabel(),
                    SideBarTile(
                      name: "Подборки",
                      onClicked: onCollectionsTap,
                      iconData: Icons.book_outlined,
                      activeIconData: Icons.book,
                    ),
                    SideBarTile(
                      name: "Создать рецепт",
                      onClicked: onConstructorTap,
                      iconData: Icons.create_outlined,
                      activeIconData: Icons.create,
                    ),
                    SideBarTile(
                      name: "Голосовые команды",
                      onClicked: onVoiceCommandsTap,
                      iconData: Icons.record_voice_over_outlined,
                      activeIconData: Icons.record_voice_over,
                    ),
                    SideBarTile(
                      name: "Понравившиеся",
                      onClicked: onFavoritesTap,
                      iconData: Icons.favorite_outline_outlined,
                      activeIconData: Icons.favorite,
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
                          fontSize: SideBarMenu.fontSize(context)),
                    ),
                    CupertinoSwitch(
                      activeColor: Colors.orangeAccent.shade200,
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

  void onCollectionsTap() {
    Routemaster.of(context).push(CollectionsListPage.route);
  }

  void onVoiceCommandsTap() {
    ServiceIO.showAlertDialog("В стадии разработки", context);
  }

  void onConstructorTap() {
    if (!ServiceIO.loggedIn) {
      ServiceIO.showCreateInviteDialog(context);
      return;
    }
    Routemaster.of(context).push(CreateRecipePage.route);
  }

  void onFavoritesTap() async {
    if (!ServiceIO.loggedIn) {
      ServiceIO.showLoginInviteDialog(context);
      return;
    }
    Routemaster.of(context).push('/favorites');
  }

  void onUserTap() async {
    // if (!ServiceIO.loggedIn) {
    //   ServiceIO.showLoginInviteDialog(context);
    //   return;
    // }
    Routemaster.of(context).push(UserPage.route);
  }

  void onProfileLabelTap() {
    Routemaster.of(context).push(AuthPage.route);
  }

  void onLoginTap() {
    Routemaster.of(context).push(LoginPage.route);
  }

  Widget buildAccountOrLoginLabel() {
    return StreamBuilder(
        stream: Stream.value(Token.isToken()),
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            return buildAccountTile();
          } else {
            return SideBarTile(
              name: "Войти",
              onClicked: onLoginTap,
              iconData: Icons.login,
              activeIconData: Icons.login_sharp,
            );
          }
        });
  }

  Color get pressedColor => Config.darkModeOn
      ? const Color(0xFF303030)
      : const Color(0xFFFbF2F1).darken(2);

  Widget buildAccountTile() {
    return Column(
      children: [
        InkWell(
          onTap: onProfileLabelTap,
          borderRadius: Config.borderRadiusLarge,
          hoverColor: pressedColor,
          child: Padding(
            padding: Config.paddingAll,
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
                      child: addImage(),
                    ),
                  ),
                ),
                const SizedBox(width: Config.margin),
                Text(
                  "${UserDB.uid}",
                  style: TextStyle(
                    fontSize: SideBarMenu.nameFontSize(context),
                    color: Config.iconColor,
                    fontFamily: Config.fontFamily,
                  ),
                ),
              ],
            ),
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
}

Widget addImage(){
  print("99999999999999999999");
  if (UserDB.image != "null"){
    print("yyyyyyyyyyyyyyyyyyy  111");
    return Image(
      image: NetworkImage(UserDB.image ?? defaultProfileUrl),
      width: 50,
      height: 50,
      fit: BoxFit.cover,
    );
  } else {
    print("yyyyyyyyyyyyyyyyyyy  222");
    return Image.asset("assets/images/user.jpg");
  }
}
