import 'package:flutter/material.dart';

import '../components/appbars/title_logo_panel.dart';
import '../config.dart';
import 'authorization/login_screen.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key,
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
                        child: LoginScreen.voiceRecipeIcon(context, 500, 300)
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
