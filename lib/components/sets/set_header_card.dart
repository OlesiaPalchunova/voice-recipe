import 'package:flutter/material.dart';
import 'package:voice_recipe/components/sets/sets_options_list.dart';

import 'package:voice_recipe/config.dart';
import 'package:voice_recipe/model/sets_info.dart';

class SetHeaderCard extends StatefulWidget {
  const SetHeaderCard({Key? key, required this.set, required this.onTap,
  this.parentWidth = 0})
      : super(key: key);

  final VoidCallback onTap;
  final RecipesSet set;
  final double parentWidth;

  @override
  State<SetHeaderCard> createState() => _SetHeaderCardState();
}

class _SetHeaderCardState extends State<SetHeaderCard>
    with SingleTickerProviderStateMixin {
  var _isPressed = false;

  @override
  Widget build(BuildContext context) {
    double cardHeight = Config.pageHeight(context) / 8;
    final _width = widget.parentWidth > 0 ? widget.parentWidth : Config.pageWidth(context);
    return GestureDetector(
      onTap: () => setState(() {
        widget.onTap();
        _isPressed = !_isPressed;
      }),
          child: Card(
            color: Colors.white.withOpacity(0),
            elevation: 0,
            margin: const EdgeInsets.symmetric(vertical: Config.margin / 2),
            child: Column(
              children: [
                Stack(children: [
                  SizedBox(
                    child: AnimatedContainer(
                      duration: Config.animationTime,
                      height: cardHeight,
                      decoration: BoxDecoration(
                          // gradient: LinearGradient(colors: gradColors),
                          border: Border.all(color: Config.iconColor(),
                              width: Config.darkModeOn ? 0.2 : 0.5),
                          borderRadius:
                              BorderRadius.circular(Config.borderRadius),
                          color: _isPressed
                              ? Config.pressed()
                              : Config.notPressed(),
                          boxShadow: _isPressed
                              ? [
                                  BoxShadow(
                                    color: Config.darkModeOn ? Config.getColor(widget.set.id)
                                    : Config.pressed(),
                                    blurRadius:8,
                                  )
                                ]
                              : []),
                      child: Row(
                        children: [
                          SizedBox(
                            width: _width * 0.5,
                          ),
                          Container(
                            width: _width * 0.4,
                            alignment: Alignment.center,
                            child: Image(
                              image: AssetImage(widget.set.imageUrl),
                              height: _isPressed
                                  ? cardHeight
                                  : cardHeight * 0.9,
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
                            fontSize: !_isPressed ? 25 : 27,
                            color: Config.iconColor())),
                  ),
                ]),
                _isPressed ? SetsOptionsList(set: widget.set) : Container()
              ],
            ),
          )
    // ),
    );
  }
}
