import 'dart:collection';

import 'package:flutter/material.dart';

import '../../config.dart';

import 'package:rive/rive.dart';

class StarPanel extends StatefulWidget {
  const StarPanel({super.key, required this.id, required this.onTap});

  final int id;
  final Function(int) onTap;

  @override
  State<StarPanel> createState() => StarPanelState();
}

class StarPanelState extends State<StarPanel> {
  late int currentRate;
  static const starsCount = 5;
  static StarPanelState? current;
  static final starsTable = HashMap<int, int>();

  StateMachineController? controller;
  SMIInput<double>? inputValue;

  @override
  void initState() {
    current = this;
    currentRate = starsTable[widget.id] ?? -1;
    super.initState();
  }

  @override
  void dispose() {
    starsTable[widget.id] = currentRate;
    super.dispose();
  }

  void clear() {
  }

  int getRate(String stateName) {
    if (stateName == "1_star") return 1;
    if (stateName == "2_stars") return 2;
    if (stateName == "3_stars") return 3;
    if (stateName == "4_stars") return 4;
    if (stateName == "5_stars") return 5;
    return 0;
  }

  String get postfix => Config.darkModeOn ? "" : "_light";

  @override
  Widget build(BuildContext context) {
    double k = Config.isDesktop(context) ? .5 : .6;
    final width = Config.loginPageWidth(context) * k;
    return InkWell(
      onTap: () {},
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: width,
          height: 80,
          child: RiveAnimation.asset('assets/RiveAssets/rating_animation$postfix.riv',
            fit: BoxFit.fitWidth,
            onInit: (artboard) {
              controller = StateMachineController.fromArtboard(
                  artboard, 'State Machine 1',
                  onStateChange: (stateMachineName, stateName) {
                    int newRate = getRate(stateName);
                    if (currentRate != newRate) {
                      currentRate = newRate;
                      widget.onTap(currentRate);
                      starsTable[widget.id] = currentRate;
                    }
                    currentRate = newRate;
                  }
              );
              if (controller == null) return;
              artboard.addController(controller!);
              inputValue = controller!.findInput<double>('rating') as SMINumber;
              if (currentRate > 0) {
                inputValue?.change(currentRate.toDouble());
              }
            }
          )
        )
      )
    );
  }
}
