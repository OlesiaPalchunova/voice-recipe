import 'package:rive/rive.dart';

class RiveUtils {
  static StateMachineController getRiveInput(Artboard artboard,
      {required String stateMachineName}) {
    StateMachineController? controller = StateMachineController.fromArtboard(
        artboard, stateMachineName);
    artboard.addController(controller!);
    return controller;
  }

  static void chnageSMIBoolState(SMIBool input) {
    input.change(true);
    Future.delayed(
      const Duration(seconds: 1),
      () {
        input.change(false);
      },
    );
  }
}
