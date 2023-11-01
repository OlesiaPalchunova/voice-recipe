import 'package:flutter/material.dart';
// import 'package:routemaster/routemaster.dart';
// import 'package:flutter_share_me/flutter_share_me.dart';

import 'package:voice_recipe/config/config.dart';

enum ShareOption {
  whatsapp,
  instagram,
  telegram
}

class ShareLabel extends StatelessWidget {
  const ShareLabel({key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Config.paddingAll,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: ShareOption.values.map((e) => buildShareIconButton(context, e)).toList(),
      ),
    );
  }

  String get imagePath => "assets/images/icons";

  String toImagePath(ShareOption type) {
    switch (type) {
      case ShareOption.whatsapp: return '$imagePath/whatsapp.png';
      case ShareOption.instagram: return'$imagePath/instagram.png';
      case ShareOption.telegram: return'$imagePath/telegram.png';
    }
  }

  double get buttonSize => 40;

  Widget buildShareIconButton(BuildContext context, ShareOption type) {
    return InkWell(
      borderRadius: Config.borderRadius,
      onHover: (h) {},
      onTap: () => onTap(context, type),
      child: SizedBox(
        height: buttonSize,
        width: buttonSize,
        child: ClipRRect(
          borderRadius: Config.borderRadius,
          child: Image.asset(
            toImagePath(type)
          ),
        ),
      ),
    );
  }

  Future<void> onTap(BuildContext context, ShareOption type) async {
    // String msg = "talkychef.ru${Routemaster.of(context).currentRoute}";
    // final FlutterShareMe flutterShareMe = FlutterShareMe();
    // switch (type) {
    //   case Share.whatsapp:
    //     await flutterShareMe.shareToWhatsApp(msg: msg);
    //     break;
    //   case Share.instagram:
    //     await flutterShareMe.shareToSystem(msg: msg);
    //     break;
    //   case Share.telegram:
    //     await flutterShareMe.shareToTelegram(msg: msg);
    //     break;
    // }
  }
}
