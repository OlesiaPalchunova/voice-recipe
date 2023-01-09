import 'dart:async';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:voice_recipe/services/rive_utils.dart';

class Tree extends StatefulWidget {
  static const String route = "tree";

  const Tree({super.key});

  @override
  State<Tree> createState() => _TreeState();
}

class _TreeState extends State<Tree> {
  late StateMachineController controller;
  late SMIInput<double> trigger;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      controller.isActive = true;
      var timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        trigger.value += 1;
        if (trigger.value > 100) {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: RiveAnimation.asset(
          "assets/RiveAssets/tree.riv",
          onInit: (artboard) {
            controller = RiveUtils.getRiveInput(artboard, stateMachineName: "State Machine 1");
            controller.isActive = false;
            trigger = controller.findInput<double>('input') as SMINumber;
            trigger.value = 0;
          },
        ),
      ),
    );
  }
}
