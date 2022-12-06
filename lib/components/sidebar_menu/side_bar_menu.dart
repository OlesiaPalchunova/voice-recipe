import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voice_recipe/components/sidebar_menu/side_bar_tile.dart';

import 'package:voice_recipe/config.dart';
import 'package:voice_recipe/recipes_getter.dart';
import 'package:voice_recipe/screens/profile_screen.dart';
import 'package:voice_recipe/screens/authorization/login_screen.dart';
import 'package:voice_recipe/screens/sets_list_screen.dart';

import '../../model/users_info.dart';
import '../../screens/set_screen.dart';

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
          thickness: 0.2,
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
            return SideBarTile(
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
                    SideBarTile(
                      name: "Подборки",
                      onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SetsListScreen(),
                      )),
                      iconData: Config.darkModeOn ? Icons.library_books_outlined
                                                  : Icons.library_books_outlined
                    ),
                    SideBarTile(
                        name: "Голосовые команды",
                        onClicked: () {
                        },
                        iconData: Config.darkModeOn ? Icons.record_voice_over_outlined
                            : Icons.record_voice_over_outlined
                    ),
                    SideBarTile(
                        name: "Понравившиеся",
                        onClicked: () async {
                          if (!Config.loggedIn) {
                            Config.showLoginInviteDialog(context);
                            return;
                          }
                          Config.showProgressCircle(context);
                          var recipes = await RecipesGetter().favoriteRecipes;
                          await Future.microtask(() => Navigator.of(context).pop());
                          await Future.microtask(() => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => SetScreen(
                                    recipes: recipes,
                                    setName: "Понравившиеся",
                                    showLikes: false,))));
                        },
                        iconData: Config.darkModeOn ? Icons.thumb_up_alt_outlined
                            : Icons.thumb_up_alt_outlined
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
