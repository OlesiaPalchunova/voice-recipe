import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:voice_recipe/components/buttons/say_button.dart';

import 'package:voice_recipe/config/config.dart';
import 'package:voice_recipe/components/buttons/listen_button.dart';


import '../../model/profile.dart';
import '../../pages/account/user_page.dart';
import '../../pages/user/user_page.dart';

class HeaderButtonsPanel extends StatelessWidget {
  const HeaderButtonsPanel({
    key,
    required this.onClose,
    required this.onList,
    required this.onListen,
    required this.onMute,
    required this.onSay,
    required this.onStopSaying,
    required this.id,
    required this.profile,
    // required this.user_id,
  });

  static const _iconSize = 25.0;
  final void Function(BuildContext) onClose;
  final void Function() onList;
  final void Function() onListen;
  final void Function() onMute;
  final void Function() onSay;
  final void Function() onStopSaying;
  final int id;
  final Profile profile;


  // final String user_id;
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
        padding: const EdgeInsets.all(3.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                buildUserIcon(context),
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

  Future getProfile() async {

  }

  Widget buildUserIcon(BuildContext context) {
    return InkWell(
      onTap: (){
        // Routemaster.of(context).push(UserAccount.route);
        print("::::::::;;;;;;;;;;;;;;;;;");
        print(profile.uid);
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserAccount(profile: profile,)));
      },
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Config.iconBackColor,
          image: DecorationImage(
              image: AssetImage('assets/images/user.jpg')
          ),
        ),
      ),
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
