import 'package:flutter/material.dart';
import 'package:voice_recipe/components/sets/sets_options_list.dart';

import 'package:voice_recipe/config.dart';
import 'package:voice_recipe/model/sets_info.dart';

import '../../screens/set_screen.dart';

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
                margin: const EdgeInsets.symmetric(vertical: 7),
                child: Column(
                  children: [
                    Stack(children: [
                      SizedBox(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: Config.pageHeight(context) / 7,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Config.borderRadius),
                              color: const Color(0xff101010),
                              boxShadow: _isPressed ?
                                  [
                                    const BoxShadow(
                                    color: Colors.white54,
                                      blurRadius: 12,
                                      // offset: Offset(16, 16)
                                  )
                                  ] :
                                  []
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: Config.pageWidth(context) * 0.6,
                              ),
                              ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(Config.borderRadius),
                                  child: Image(
                                    image: AssetImage(widget.set.imageUrl),
                                    // fit: BoxFit.fitWidth,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(30, 35, 0, 50),
                        child: Text(
                          widget.set.name,
                          style: const TextStyle(
                              fontFamily: Config.fontFamilyBold,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ]),
                    _isPressed
                        ? SetsOptionsList(set: widget.set)
                        : Container()
                  ],
                )),
          ),
        );
  }

  void _navigateToSet(BuildContext context, RecipesSet set) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SetScreen(set: set)));
  }
}
