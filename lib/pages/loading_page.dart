import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../config.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key, this.postfix = ''});

  final String postfix;

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
                    Stack(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 300,
                          child: const RiveAnimation.asset('assets/RiveAssets/book_loading.riv'),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          height: 300,
                          padding: Config.paddingAll,
                          child: Text("Загружаем$postfix...",
                            style: TextStyle(
                                color: Config.iconColor,
                                fontSize: Config.isDesktop(context) ? 24 : 22,
                                fontFamily: Config.fontFamily
                            ),),
                        )
                      ],
                    ),
                    const SizedBox(height: 200,)
                  ],
                ),
            )
        )
    );
  }
}
