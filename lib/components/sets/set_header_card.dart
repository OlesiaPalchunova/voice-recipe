import 'package:flutter/material.dart';
import 'package:voice_recipe/components/sets/sets_options_list.dart';

import 'package:voice_recipe/config.dart';
import 'package:voice_recipe/model/sets_info.dart';

class SetHeaderCard extends StatefulWidget {
  const SetHeaderCard(
      {Key? key, required this.set, required this.onTap, this.widthConstraint = 0,
      this.showTiles = true})
      : super(key: key);

  final VoidCallback onTap;
  final RecipesSet set;
  final double widthConstraint;
  final bool showTiles;

  @override
  State<SetHeaderCard> createState() => _SetHeaderCardState();
}

class _SetHeaderCardState extends State<SetHeaderCard>
    with SingleTickerProviderStateMixin {
  var _isPressed = false;
  var _isHovered = false;

  bool get active => _isPressed || _isHovered;

  @override
  Widget build(BuildContext context) {
    double cardHeight = Config.pageHeight(context) / 10;
    final width =
        widget.widthConstraint > 0 ? widget.widthConstraint : Config.pageWidth(context);
    return InkWell(
      onHover: (hovered) => setState(() {
        _isHovered = hovered;
      }),
      onTap: () async {
        setState(() {
          widget.onTap();
          _isPressed = !_isPressed;
        });
        if (widget.showTiles | !_isPressed) {
          return;
        }
        await Future.delayed(Config.shortAnimationTime).whenComplete(() {
          setState(() {
            _isPressed = false;
          });
        });
      },
      child: Card(
        elevation: 0,
        color: Colors.white.withOpacity(0),
        margin: const EdgeInsets.symmetric(vertical: Config.margin / 2),
        child: Column(
          children: [
            Stack(children: [
              SizedBox(
                child: AnimatedContainer(
                  duration: Config.animationTime,
                  height: cardHeight,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: active
                              ? Config.iconColor
                              : Config.notPressed,
                          width: 0.2),
                      borderRadius: BorderRadius.circular(Config.borderRadius),
                      color:
                          active ? Config.pressed : Config.notPressed,
                      boxShadow: active
                          ? [
                              BoxShadow(
                                color: Config.darkModeOn
                                    ? Config.getColor(widget.set.id)
                                    : Config.getColor(widget.set.id),
                                blurRadius: 8,
                              )
                            ]
                          : []),
                  child: Row(
                    children: [
                      SizedBox(
                        width: width * 0.5,
                      ),
                      Container(
                        width: width * 0.4,
                        alignment: Alignment.center,
                        child: Image(
                          image: AssetImage(widget.set.imageUrl),
                          height: active ? cardHeight : cardHeight * 0.9,
                          // fit: BoxFit.fitWidth,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: cardHeight,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: Config.padding * 2),
                child: Text(widget.set.name,
                    style: TextStyle(
                        fontFamily: Config.fontFamily,
                        fontSize: !active
                            ? fontSize(context)
                            : fontSize(context) + 2,
                        color: Config.iconColor)),
              ),
            ]
            ),
            _isPressed & widget.showTiles ? SetsOptionsList(set: widget.set) : Container(),
          ],
        ),
      ),
    );
  }

  double fontSize(BuildContext context) => Config.isDesktop(context)
      ? 22 : 20;
}
