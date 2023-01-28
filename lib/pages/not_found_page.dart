import 'package:flutter/material.dart';

import 'package:voice_recipe/components/appbars/title_logo_panel.dart';
import 'package:voice_recipe/config/config.dart';
import 'package:voice_recipe/pages/account/login_page.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key,
  this.message = defaultMessage});

  static const defaultMessage = "Страница, которую вы запрашиваете, не найдена";
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const TitleLogoPanel(title: "Страница не найдена").appBar(),
        backgroundColor: Config.backgroundEdgeColor,
        body: Center(
            child: Container(
                alignment: Alignment.center,
                width: Config.loginPageWidth(context),
                child: Column(
                  children: [
                    Container(
                        height: 500,
                        alignment: Alignment.center,
                        child: LoginPage.voiceRecipeIcon(context, 500, 300)
                    ),
                    Text(message,
                    style: TextStyle(
                      color: Config.darkModeOn ? Colors.white : Colors.black,
                      fontSize: Config.isDesktop(context) ? 22 : 20,
                      fontFamily: Config.fontFamily
                    ),)
                  ],
                ),
            )
        )
    );
  }
}
