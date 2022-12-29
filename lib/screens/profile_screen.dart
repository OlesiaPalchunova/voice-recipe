import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voice_recipe/components/appbars/title_logo_panel.dart';
import 'package:voice_recipe/components/recipe_collection_views/set_header_card.dart';
import 'package:voice_recipe/screens/set_screen.dart';

import '../api/recipes_getter.dart';
import '../config.dart';
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
                        onTap: () async {
                          if (!Config.loggedIn) {
                            Config.showLoginInviteDialog(context);
                            return;
                          }
                          Config.showProgressCircle(context);
                          var recipes = await RecipesGetter().createdRecipes;
                          await Future.microtask(() => Navigator.of(context).pop());
                          await Future.microtask(() => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => SetScreen(
                                    recipes: recipes,
                                    setName: "Созданные вами",
                                    showLikes: false,)
                              )
                          ));
                        },
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
