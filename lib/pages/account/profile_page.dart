import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:voice_recipe/components/appbars/title_logo_panel.dart';
import 'package:voice_recipe/components/recipe_collection_views/collection_header_card.dart';

import 'package:voice_recipe/config/config.dart';
import 'package:voice_recipe/model/sets_info.dart';
import 'package:voice_recipe/model/users_info.dart';
import 'package:voice_recipe/pages/collections/future_collection_page.dart';
import 'package:voice_recipe/services/service_io.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TitleLogoPanel(title: "Профиль").appBar(),
      backgroundColor: Config.backgroundEdgeColor,
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
                  Container(
                      padding: const EdgeInsets.all(Config.padding),
                      alignment: Alignment.center,
                      child: CollectionHeaderCard(
                        onTap: () async {
                          if (!ServiceIO.loggedIn) {
                            ServiceIO.showLoginInviteDialog(context);
                            return;
                          }
                          Routemaster.of(context).push('/created');
                        },
                        hasSubtitles: false,
                        set: created,
                        widthConstraint: Config.loginPageWidth(context),
                      )
                  )
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
                fontSize: 16,
                color: Config.iconColor,
                fontFamily: Config.fontFamily,
              ),
            ),
          ],
        ),
        IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Routemaster.of(context).pop();
            },
            tooltip: "Выйти из аккаунта",
            icon: Icon(Icons.logout, color: Config.iconColor))
      ],
    );
  }
}
