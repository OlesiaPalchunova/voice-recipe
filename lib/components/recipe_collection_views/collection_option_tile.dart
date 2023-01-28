import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:voice_recipe/pages/collections/future_collection_page.dart';

import '../../config/config.dart';
import '../../model/sets_info.dart';
import 'package:voice_recipe/components/buttons/classic_button.dart';

class CollectionOptionTile extends StatefulWidget {
  const CollectionOptionTile({Key? key, required this.setOption})
      : super(key: key);

  final Collection setOption;

  @override
  State<CollectionOptionTile> createState() => _CollectionOptionTileState();
}

class _CollectionOptionTileState extends State<CollectionOptionTile> {
  bool pressed = false;
  bool disposed = false;

  Color get hoverColor =>
      Config.darkModeOn ? ClassicButton.hoverColor : Colors.white;

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          pressed = true;
        });
      },
      borderRadius: Config.borderRadiusLarge,
      hoverColor: Config.pressed,
      child: AnimatedContainer(
        duration: Config.shortAnimationTime,
        onEnd: () async {
          if (pressed) {
            _navigateToSet(context, widget.setOption);
          }
          await Future.delayed(Config.animationTime).whenComplete(() {
            if (disposed) return;
            setState(() {
              pressed = false;
            });
          });
        },
        decoration: BoxDecoration(
          borderRadius: Config.borderRadius,
          color: pressed ? Config.pressed : null,
        ),
        width: Config.pageWidth(context),
        margin: const EdgeInsets.symmetric(horizontal: Config.margin * 2),
        padding: const EdgeInsets.symmetric(
                vertical: Config.padding * 0.5,
                horizontal: Config.padding * 0.5)
            .add(const EdgeInsets.only(top: 0.5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
                textBaseline: TextBaseline.ideographic,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.setOption.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: fontSize(context),
                          fontFamily: Config.fontFamily,
                          fontWeight: FontWeight.w500,
                          color: Config.iconColor)),
                  Text(
                    "",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: fontSize(context),
                        fontFamily: Config.fontFamily,
                        fontWeight: FontWeight.w500,
                        color: Config.iconColor),
                  ),
                ]),
            Divider(
              color: pressed
                  ? Config.pressed
                  : Config.iconColor.withOpacity(0.5),
              thickness: 0.2,
              indent: 0.0,
              endIndent: 0.0,
            )
          ],
        ),
      ),
    );
  }

  double fontSize(BuildContext context) => Config.isDesktop(context) ? 20 : 18;

  void _navigateToSet(BuildContext context, Collection setOption) async {
    Routemaster.of(context)
        .push('${FutureCollectionPage.route}${setOption.collectionName}');
  }
}
