import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../config.dart';
import '../../model/db/favorite_recipes_db_manager.dart';
import 'package:rive/rive.dart';

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
  bool _pressed = false;
  bool _listen = false;
  bool _disposed = false;
  SMIBool? hovered;
  SMIBool? pressed;

  void _onLikeInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (controller == null) return;
    artboard.addController(controller!);
    hovered = controller.findInput<bool>('Hover') as SMIBool;
    pressed = controller.findInput<bool>('Pressed') as SMIBool;
    if (_pressed) {
      hovered?.change(true);
      pressed?.change(true);
    } else {
      pressed?.change(false);
    }
  }

  @override
  void initState(){
    if (Config.loggedIn) {
      checkIfIsFavorite();
    }
    _disposed = false;
    setAuthListener();
    super.initState();
  }

  @override
  void dispose() {
    _disposed = true;
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

  List<BoxShadow> get shadows => [];

  String get postfix => Config.darkModeOn ? "_dark" : "_light";

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              boxShadow: shadows,
              color: Config.edgeColor,
              borderRadius: Config.borderRadiusLarge),
          width: width * .8,
          height: width * .8,
          // margin: EdgeInsets.only(top: width / 15),
        ),
        InkWell(
          onTap: () {
            if (!Config.loggedIn) {
              Config.showLoginInviteDialog(context);
              return;
            }
            _pressed = !_pressed;
            pressed?.change(_pressed);
            if (_pressed) {
              FavoriteRecipesDbManager().add(widget.recipeId);
            } else {
              FavoriteRecipesDbManager().remove(widget.recipeId);
            }
          },
          onHover: (h) {
            hovered?.change(h);
          },
          child: Container(
            width: width,
            height: width,
            child: SizedBox(
              child: RiveAnimation.asset("assets/RiveAssets/like$postfix.riv",
                onInit: _onLikeInit
              )
            ),
          )
        )
      ],
    );
  }

  void onPressed() {
    setState(() {
      _pressed = !_pressed;
      if (_pressed) {
        FavoriteRecipesDbManager().add(widget.recipeId);
      } else {
        FavoriteRecipesDbManager().remove(widget.recipeId);
      }
    });
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
    _pressed = await FavoriteRecipesDbManager().isFavorite(widget.recipeId);
    if (_disposed) {
      return;
    }
    if (_pressed) {
      hovered?.change(true);
      pressed?.change(true);
    } else {
      pressed?.change(false);
    }
  }
}
