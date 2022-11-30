import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voice_recipe/components/appbars/title_logo_panel.dart';
import 'package:voice_recipe/components/login/button.dart';
import 'package:voice_recipe/components/sets/set_header_card.dart';
import 'package:voice_recipe/model/db/user_db_manager.dart';
import 'package:voice_recipe/recipes_getter.dart';
import 'package:voice_recipe/screens/set_screen.dart';

import '../config.dart';
import '../model/recipes_info.dart';
import '../model/sets_info.dart';
import '../model/users_info.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TitleLogoPanel(title: "Профиль").appBar(),
      backgroundColor: Config.backgroundColor,
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: Config.loginPageWidth(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: const EdgeInsets.all(Config.padding),
                  alignment: Alignment.center,
                  child: buildProfile(
                      FirebaseAuth.instance.currentUser!, context)
              ),
              Column(
                children: [
                  Divider(
                    color: Config.iconColor,
                    thickness: 0.2,
                  ),
                  Container(
                      padding: const EdgeInsets.all(Config.padding),
                      alignment: Alignment.center,
                      child: SetHeaderCard(
                        onTap: () {},
                        showTiles: false,
                        set: created,
                        widthConstraint: Config.loginPageWidth(context),
                      )
                  ),
                  Divider(
                    color: Config.iconColor,
                    thickness: 0.2,
                  ),
                ],
              ),
              Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfile(User user, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Config.backgroundColor,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.network(user.photoURL ?? defaultProfileUrl),
                ),
              ),
            ),
            const SizedBox(width: Config.margin * 2),
            Text(
              "${user.displayName}",
              style: TextStyle(
                fontSize: 18,
                color: Config.iconColor,
                fontFamily: Config.fontFamily,
              ),
            ),
          ],
        ),
        IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.logout, color: Config.iconColor))
      ],
    );
  }
}

/*
Container(
                  padding: const EdgeInsets.all(Config.padding)
                      .add(const EdgeInsets.only(top: Config.margin * 3)),
                  alignment: Alignment.center,
                  child: SetHeaderCard(
                    onTap: () async {
                      Config.showProgressCircle(context);
                      var recipes = await RecipesGetter().favoriteRecipes;
                      await Future.microtask(() => Navigator.of(context).pop());
                      await Future.microtask(() => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => SetScreen(
                                  recipes: recipes,
                                  setName: "Избранное",
                                  showLikes: false,))));
                    },
                    showTiles: false,
                    set: fav,
                    widthConstraint: Config.loginPageWidth(context),
                  )),
              Divider(
                color: Config.iconColor,
                thickness: 0.2,
              ),
 */