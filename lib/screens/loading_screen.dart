import 'package:flutter/material.dart';

import '../config.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Config.defaultAppBar,
        backgroundColor: Config.backgroundEdgeColor,
        body: Center(
            child: Container(
                alignment: Alignment.center,
                width: Config.loginPageWidth(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 100,
                      child: const CircularProgressIndicator(),
                    ),
                    Text("Загружаем...",
                      style: TextStyle(
                          color: Config.iconColor,
                          fontSize: Config.isDesktop(context) ? 20 : 18,
                          fontFamily: Config.fontFamily
                      ),)
                  ],
                ),
            )
        )
    );
  }
}
