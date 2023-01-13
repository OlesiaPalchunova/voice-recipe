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

  static final Map<int, ValueNotifier<bool>> notifyers = {};

  void _onLikeInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (controller == null) return;
    artboard.addController(controller);
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
    _disposed = false;
    if (!notifyers.containsKey(widget.recipeId)) {
      notifyers[widget.recipeId] = ValueNotifier(false);
    }    
    if (Config.loggedIn) {
      checkIfIsFavorite();
    }
    setAuthListener();
    super.initState();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

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
        ValueListenableBuilder(
          valueListenable: notifyers[widget.recipeId]!,
          builder: (BuildContext context, bool isFav, Widget? child) {
            Widget res = InkWell(
              onTap: () {
                if (!Config.loggedIn) {
                  Config.showLoginInviteDialog(context);
                  return;
                }
                _pressed = !_pressed;
                notifyers[widget.recipeId]!.value = _pressed;
                if (_pressed) {
                  FavoriteRecipesDbManager().add(widget.recipeId);
                } else {
                  FavoriteRecipesDbManager().remove(widget.recipeId);
                }
                hovered?.change(_pressed);
                pressed?.change(_pressed);
              },
              onHover: (h) {
                hovered?.change(h);
              },
              child: SizedBox(
                width: width,
                height: width,
                child: SizedBox(
                  child: RiveAnimation.asset("assets/RiveAssets/like$postfix.riv",
                    onInit: _onLikeInit
                  )
                ),
              )
            );
            if (_pressed != isFav) {
              hovered?.change(isFav);
              pressed?.change(isFav);
              _pressed = isFav;
            }
            return res;
          }
        )
      ],
    );
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
    bool isFav = await FavoriteRecipesDbManager().isFavorite(widget.recipeId);
    notifyers[widget.recipeId]!.value = isFav;
  }
}
