import 'package:flutter/material.dart';
import 'package:voice_recipe/components/buttons/say_button.dart';

import 'package:voice_recipe/config/config.dart';
import 'package:voice_recipe/components/buttons/listen_button.dart';

class HeaderButtonsPanel extends StatelessWidget {
  const HeaderButtonsPanel({
    super.key,
    required this.onClose,
    required this.onList,
    required this.onListen,
    required this.onMute,
    required this.onSay,
    required this.onStopSaying,
    required this.id,
  });

  static const _iconSize = 25.0;
  final void Function(BuildContext) onClose;
  final void Function() onList;
  final void Function() onListen;
  final void Function() onMute;
  final void Function() onSay;
  final void Function() onStopSaying;
  final int id;
  static final isListening = ValueNotifier(false);
  static final isLockedListening = ValueNotifier(false);
  static final isSaying = ValueNotifier(false);

  static Container buildButton(IconButton iconButton, Color color) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: color,
        ),
        child: iconButton);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(Config.padding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                buildAppIcon(),
                const SizedBox(
                  width: 10,
                ),
                ListenButton(
                    onListen: onListen,
                    onMute: onMute,
                    iconSize: _iconSize,
                    listenNotifyer: isListening,
                    isLocked: isLockedListening)
              ],
            ),
            SayButton(
                onSay: onSay,
                onStopSaying: onStopSaying,
                iconSize: _iconSize,
                sayNotyfyer: isSaying),
            Row(
              children: [
                buildListButton(),
                const SizedBox(
                  width: 10,
                ),
                buildCloseButton(context)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildAppIcon() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Config.iconBackColor,
      ),
      child: const Image(
          height: _iconSize * 1.65,
          image: AssetImage("assets/images/voice_recipe.png")),
    );
  }

  Widget buildListButton() {
    return HeaderButtonsPanel.buildButton(
        IconButton(
          tooltip: "Список ингредиентов",
          onPressed: onList,
          icon: Icon(
            Icons.list,
            color: Config.iconColor,
            size: HeaderButtonsPanel._iconSize,
          ),
        ),
        Config.iconBackColor);
  }

  Widget buildCloseButton(BuildContext context) {
    return HeaderButtonsPanel.buildButton(
        IconButton(
          tooltip: "Закрыть рецепт",
          onPressed: () => onClose(context),
          icon: Icon(
            Icons.close_outlined,
            color: Config.iconColor,
            size: HeaderButtonsPanel._iconSize,
          ),
        ),
        Config.iconBackColor);
  }
}
