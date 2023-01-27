import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:voice_recipe/components/utils/custom_positioned.dart';

class AnimatedLoading {
    AnimatedLoading._internal();

    bool isShowLoading = false;
    bool isShowConfetti = false;
    SMITrigger? error;
    SMITrigger? success;
    SMITrigger? reset;
    SMITrigger? confetti;

    void _onCheckRiveInit(Artboard artboard) {
        StateMachineController? controller =
            StateMachineController.fromArtboard(artboard, 'State Machine 1');
        artboard.addController(controller!);
        error = controller.findInput<bool>('Error') as SMITrigger;
        success = controller.findInput<bool>('Check') as SMITrigger;
        reset = controller.findInput<bool>('Reset') as SMITrigger;
    }

    void _onConfettiRiveInit(Artboard artboard) {
        StateMachineController? controller =
            StateMachineController.fromArtboard(artboard, "State Machine 1");
        artboard.addController(controller!);
        confetti = controller.findInput<bool>("Trigger explosion") as SMITrigger;
    }

    factory AnimatedLoading() {
        return AnimatedLoading._internal();
    }

    Future<bool> execute(BuildContext context, {required Future<bool> Function() task, 
    required VoidCallback onSuccess}) async {
        showDialog(
            barrierColor: Colors.transparent,
            context: context,
            builder: (content) => Center(
                child: CustomPositioned(
                topOffset: 200,
                scale: 6,
                child: RiveAnimation.asset(
                    "assets/RiveAssets/confetti.riv",
                    onInit: _onConfettiRiveInit,
                    fit: BoxFit.cover,
                ),
            ),
        ));
        showDialog(
            barrierColor: Colors.transparent,
            context: context,
            builder: (content) => Center(
                child: CustomPositioned(
                topOffset: 200,
                child: RiveAnimation.asset(
                    'assets/RiveAssets/check.riv',
                    fit: BoxFit.cover,
                    onInit: _onCheckRiveInit,
                    ),
                ),
            )
        );
        bool completed = await task();
        if (completed) {
            success?.fire();
            Future.delayed(const Duration(seconds: 2), () {
                Navigator.of(context).pop();
                confetti?.fire();
                Future.delayed(const Duration(seconds: 1), () {
                    Navigator.of(context).pop();
                    onSuccess();
                }
                );
            },
            );
        } else {
            error?.fire();
            Future.delayed(const Duration(seconds: 2), () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
            },
            );
        }
        return completed;
    }
 }

