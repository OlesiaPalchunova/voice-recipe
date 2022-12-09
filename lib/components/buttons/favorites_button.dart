import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voice_recipe/model/db/user_db_manager.dart';

import '../../config.dart';

class FavoritesButton extends StatefulWidget {
  const FavoritesButton(
      {super.key,
        required this.recipeId,
      this.width = 60, this.shadowOn = true
      });

  final int recipeId;
  final double width;
  final bool shadowOn;

  @override
  State<FavoritesButton> createState() => _FavoritesButtonState();
}

class _FavoritesButtonState extends State<FavoritesButton>
    with TickerProviderStateMixin {
  late final AnimationController animationController;
  bool _pressed = false;
  bool _listen = false;
  bool _disposed = false;

  @override
  void initState(){
    if (Config.loggedIn) {
      checkIfIsFavorite();
    }
    _disposed = false;
    setAuthListener();
    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              animationController.reset();
            }
          });
    super.initState();
  }

  @override
  void dispose() {
    _disposed = true;
    animationController.dispose();
    super.dispose();
  }

  Icon get icon => _pressed
      ? Icon(
          Icons.favorite,
          color: Colors.red,
          size: widget.width / 3,
        )
      : Icon(
          Icons.favorite_outline_outlined,
          color: Config.iconColor.withOpacity(.5),
          size: widget.width / 3,
        );

  double get width => widget.width;

  List<BoxShadow> get shadows => widget.shadowOn
  ? [BoxShadow(color: Config.iconColor.withOpacity(0.5), blurRadius: 0, spreadRadius: 0.5)]
  : [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              boxShadow: shadows,
              color: Config.darkModeOn ? Config.darkBlue : Colors.white,
              borderRadius: Config.borderRadiusLarge),
          width: width,
          height: width / 2,
          margin: EdgeInsets.only(top: width / 15),
        ),
        FadeTransition(
          opacity: Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
              parent: animationController,
              curve: Curves.fastLinearToSlowEaseIn)),
          child: SlideTransition(
            position: Tween<Offset>(
                    begin: const Offset(0, 0), end: const Offset(0, -1))
                .animate(CurvedAnimation(
                    parent: animationController,
                    curve: Curves.fastLinearToSlowEaseIn)),
            child: Container(
              alignment: Alignment.topCenter,
              width: width,
              height: width / 2,
              child: IconButton(
                icon: icon,
                onPressed: () {},
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.topCenter,
          width: width,
          height: width / 2,
          child: IconButton(
            icon: icon,
            onPressed: () {
              if (!Config.loggedIn) {
                Config.showLoginInviteDialog(context);
                return;
              }
              setState(() {
                _pressed = !_pressed;
                animationController.forward();
                if (_pressed) {
                  addToFavorites();
                } else {
                  removeFromFavorites();
                }
              });
            },
          ),
        ),
      ],
    );
  }

  void addToFavorites() {
    if (!Config.loggedIn) return;
    var user = Config.user!;
    UserDbManager().addNewFavorite(user.uid, widget.recipeId);
  }

  void setAuthListener() {
    if (_listen) return;
    _listen = true;
    FirebaseAuth.instance.authStateChanges().listen(
            (event) => checkIfIsFavorite());
  }

  void checkIfIsFavorite() async {
    if (_disposed) {
      return;
    }
    _pressed = await isFavorite();
    setState(() {
    });
  }

  Future<bool> isFavorite() async {
    if (!Config.loggedIn) return false;
    var user = Config.user!;
    try {
      var userData = await UserDbManager().getUserData(user.uid);
      List favIds = userData[UserDbManager.favorites];
      return favIds.contains(widget.recipeId);
    } on Error catch(e) {
      debugPrint(e.toString());
      return false;
    }
  }

  void removeFromFavorites() {
    if (!Config.loggedIn) return;
    var user = Config.user!;
    UserDbManager().removeFavorite(user.uid, widget.recipeId);
  }
}