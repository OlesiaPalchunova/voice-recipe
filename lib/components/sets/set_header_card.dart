import 'package:flutter/material.dart';
import 'package:voice_recipe/components/sets/sets_options_list.dart';

import 'package:voice_recipe/config.dart';
import 'package:voice_recipe/model/sets_info.dart';

class SetHeaderCard extends StatefulWidget {
  const SetHeaderCard({Key? key, required this.set, required this.onTap})
      : super(key: key);

  final VoidCallback onTap;
  final RecipesSet set;

  @override
  State<SetHeaderCard> createState() => _SetHeaderCardState();
}

class _SetHeaderCardState extends State<SetHeaderCard>
    with SingleTickerProviderStateMixin {
  late final _menuTitles = optionsResolve[widget.set.id - 1];
  static const _initialDelayTime = Duration(milliseconds: 50);
  static const _staggerTime = Duration(milliseconds: 50);
  static const _buttonDelayTime = Duration(milliseconds: 150);
  static const _buttonTime = Duration(milliseconds: 300);
  late final _animationDuration = _initialDelayTime +
      (_staggerTime * _menuTitles.length) +
      _buttonDelayTime +
      _buttonTime;

  late AnimationController _staggeredController;
  late Interval _buttonInterval;
  var _isPressed = false;

  @override
  void initState() {
    super.initState();
    _createAnimationIntervals();
    _staggeredController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..forward();
  }

  void _createAnimationIntervals() {
    const buttonStartTime = _buttonDelayTime;
    final buttonEndTime = buttonStartTime + _buttonTime;
    _buttonInterval = Interval(
      buttonStartTime.inMilliseconds / _animationDuration.inMilliseconds,
      buttonEndTime.inMilliseconds / _animationDuration.inMilliseconds,
    );
  }

  @override
  void dispose() {
    _staggeredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double cardHeight = Config.pageHeight(context) / 8;
    return GestureDetector(
      onTap: () => setState(() {
        _isPressed = !_isPressed;
      }),
          child: Card(
            color: Colors.white.withOpacity(0),
            elevation: 0,
            margin: const EdgeInsets.symmetric(vertical: Config.margin),
            child: Column(
              children: [
                Stack(children: [
                  SizedBox(
                    child: AnimatedContainer(
                      duration: Config.animationTime,
                      height: cardHeight,
                      decoration: BoxDecoration(
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
                                    color: Config.getColor(widget.set.id),
                                    blurRadius:8,
                                    // offset: Offset(16, 16)
                                  )
                                ]
                              : []),
                      child: Row(
                        children: [
                          SizedBox(
                            width: Config.pageWidth(context) * 0.5,
                          ),
                          Container(
                            width: Config.pageWidth(context) * 0.4,
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
