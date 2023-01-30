import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../config/config.dart';
import '../../services/db/favorite_recipes_db_manager.dart';
import 'package:rive/rive.dart';
import 'package:voice_recipe/services/service_io.dart';

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
  bool pressed = false;
  bool listening = false;
  bool disposed = false;
  SMIBool? hoveredController;
  SMIBool? pressedController;

  static final Map<int, ValueNotifier<bool>> notifyers = {};

  void _onLikeInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (controller == null) return;
    artboard.addController(controller);
    hoveredController = controller.findInput<bool>('Hover') as SMIBool;
    pressedController = controller.findInput<bool>('Pressed') as SMIBool;
    if (pressed) {
      hoveredController?.change(true);
      pressedController?.change(true);
    } else {
      pressedController?.change(false);
    }
  }

  @override
  void initState(){
    disposed = false;
    if (!notifyers.containsKey(widget.recipeId)) {
      notifyers[widget.recipeId] = ValueNotifier(false);
    }    
    if (ServiceIO.loggedIn) {
      checkIfIsFavorite();
    }
    setAuthListener();
    super.initState();
  }

  @override
  void dispose() {
    disposed = true;
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
              borderRadius: Config.borderRadiusLarge,
              onTap: onTap,
              onHover: onHover,
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
            if (pressed != isFav) {
              hoveredController?.change(isFav);
              pressedController?.change(isFav);
              pressed = isFav;
            }
            return res;
          }
        )
      ],
    );
  }

  void onTap() {
    if (!ServiceIO.loggedIn) {
      ServiceIO.showLoginInviteDialog(context);
      return;
    }
    pressed = !pressed;
    notifyers[widget.recipeId]!.value = pressed;
    if (pressed) {
      FavoriteRecipesDbManager().add(widget.recipeId);
    } else {
      FavoriteRecipesDbManager().remove(widget.recipeId);
    }
    hoveredController?.change(pressed);
    pressedController?.change(pressed);
  }

  void onHover(bool h) {
    hoveredController?.change(h);
  }

  void setAuthListener() {
    if (listening) return;
    listening = true;
    FirebaseAuth.instance.authStateChanges().listen(
            (event) => checkIfIsFavorite());
  }

  void checkIfIsFavorite() async {
    if (disposed) {
      return;
    }
    bool isFav = await FavoriteRecipesDbManager().isFavorite(widget.recipeId);
    notifyers[widget.recipeId]!.value = isFav;
  }
}
