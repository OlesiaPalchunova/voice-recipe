import 'package:flutter/material.dart';
import 'package:voice_recipe/config.dart';
import 'package:voice_recipe/components/labels/input_label.dart';
import 'package:rive/rive.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key, required this.onChanged});

  final Function(String) onChanged;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController controller = TextEditingController();
  SMIBool? hovered;

  void _onInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (controller == null) return;
    artboard.addController(controller);
    hovered = controller.findInput<bool>('isHover') as SMIBool;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String get postfix => Config.darkModeOn ? "_dark" : "_light";

  double iconSize(BuildContext context) => Config.isDesktop(context) ? 30 : 15;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Config.isDesktop(context) ? 60 : 40,
      child: InputLabel(
          labelText: "Поиск",
          controller: controller,
          prefixIcon: Container(
              width: iconSize(context),
              height: iconSize(context),
              padding: const EdgeInsets.all(5.0),
              child: RiveAnimation.asset("assets/RiveAssets/search$postfix.riv",
                  onInit: _onInit)),
          onChanged: (s) {
            if (s.isEmpty) {
              hovered?.change(false);
            } else {
              hovered?.change(true);
            }
            widget.onChanged(s);
          },
          onSubmit: () => hovered?.change(false)),
    );
  }
}
