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
    List<Color> gradientColors = Config.darkModeOn ? [
    Config.backgroundColor(),
        Config.backgroundColor(),
    Config.pressed(),
    Config.backgroundColor(), ] : [Config.backgroundColor(),
    Config.backgroundColor()];
    return GestureDetector(
      onTap: () => setState(() {
        _isPressed = !_isPressed;
      }),
      child: AnimatedBuilder(
          animation: _staggeredController,
          builder: (context, child) {
            final animationPercent = Curves.elasticOut.transform(
                _buttonInterval.transform(_staggeredController.value));
            final opacity = animationPercent.clamp(0.0, 1.0);
            final scale = (animationPercent * 0.5) + 0.5;
            return Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: scale,
                child: child,
              ),
            );
          },
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
                      height: Config.pageHeight(context) / 7,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: gradientColors,
                            // begin: Alignment.topCenter,
                            // end: Alignment.bottomCenter
                          ),
                          border: Border.all(color: Config.iconColor(),
                              width: Config.darkModeOn ? 0.2 : 0.5),
                          borderRadius:
                              BorderRadius.circular(Config.borderRadius),
                          color: _isPressed
                              ? Config.backgroundColor()
                              : Config.iconBackColor(),
                          boxShadow: _isPressed
                              ? [
                                  BoxShadow(
                                    color: Config.getColor(widget.set.id),
                                    blurRadius: Config.darkModeOn ? 15 : 8,
                                    // offset: Offset(16, 16)
                                  )
                                ]
                              : []),
                      child: Row(
                        children: [
                          SizedBox(
                            width: Config.pageWidth(context) * 0.6,
                          ),
                          Image(
                            image: AssetImage(widget.set.imageUrl),
                            height: _isPressed
                                ? Config.pageHeight(context) / 7
                                : Config.pageHeight(context) / 8,
                            // fit: BoxFit.fitWidth,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(30, 35, 0, 50),
                    child: Text(widget.set.name,
                        style: TextStyle(
                            fontFamily: Config.fontFamily,
                            fontSize: 25,
                            color: Config.iconColor())),
                  ),
                ]),
                _isPressed ? SetsOptionsList(set: widget.set) : Container()
              ],
            ),
          )),
    );
  }
}
