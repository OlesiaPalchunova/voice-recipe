import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voice_recipe/model/collections_info.dart';

import '../../config/config.dart';
import '../../model/collection.dart';
import '../../model/collection_choice.dart';
import '../../model/collection_model.dart';
import '../../services/db/collection_db.dart';
import '../../services/db/favorite_recipes_db_manager.dart';
import 'package:rive/rive.dart';
import 'package:voice_recipe/services/service_io.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class FavoritesButton extends StatefulWidget {
  const FavoritesButton(
      {super.key,
        required this.recipeId, this.collectionId = -1,
      this.width = 60, this.shadowOn = true, this.isSaved = false
      });

  final int recipeId;
  final int collectionId;
  final double width;
  final bool shadowOn;
  final bool isSaved;

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

  bool isAdded = false;

  void collectionChoiceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CollectionChoice(recipe_id: widget.recipeId);
      },
    );
  }

  void removalConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text("Вы точно хотите удалить рецепт из коллекции?"),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                onPressed: () {
                  var collection = CollectionDB();
                  collection.deleteRecipeFromCollection(widget.collectionId, widget.recipeId);
                  Navigator.of(context).pop();
                },
                child: Text("Да"),
              ),
            ),
          ],
        );
      },
    );
  }

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
          width: width * 1.4,
          height: width * .8,
          child:Row(
            children: [
              SizedBox(
                width: 30,
                  child: IconButton(
                      onPressed: (){
                        if (!widget.isSaved) collectionChoiceDialog(context);
                        else removalConfirmation(context);
                        print("777");
                      },
                      icon: !widget.isSaved ? Icon(
                          Icons.add_box,
                        color: Colors.deepOrangeAccent,
                      ) : Icon(
                          Icons.delete_outline,
                        color: Colors.deepOrangeAccent,
                      )
                  )
              ),
              // SizedBox(width: 10,),
              ValueListenableBuilder(
                  valueListenable: notifyers[widget.recipeId]!,
                  builder: (BuildContext context, bool isFav, Widget? child) {
                    Widget res = InkWell(
                        borderRadius: Config.borderRadiusLarge,
                        onTap: onTap,
                        onHover: onHover,
                            child: Container(
                                width: 50,
                                height: 80,
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Transform.scale(
                                    scale: 1.5,
                                    child: RiveAnimation.asset("assets/RiveAssets/like$postfix.riv",
                                        onInit: (Artboard artboard) {
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
                                    ),
                                  ),
                                )
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
          ),
          // margin: EdgeInsets.only(top: width / 15),
        ),


      ],
    );
  }

  Future Add() async {
    var status = await CollectionDB().addLikedCollection(recipe_id: widget.recipeId);
    CollectionsInfo.init();
    print(11111);
    print(status);
    if (status == 200) {
      print(22222);
      hoveredController?.change(pressed);
      pressedController?.change(pressed);
    }
  }

  Future Remove() async {
    var collectionId = CollectionsInfo.favoriteCollection.id;
    var status = await CollectionDB().deleteRecipeFromCollection(collectionId, widget.recipeId);
    CollectionsInfo.init();
    if (status == 200) {
      hoveredController?.change(pressed);
      pressedController?.change(pressed);
    }
  }

  void onTap() {
    if (!ServiceIO.loggedIn) {
      ServiceIO.showLoginInviteDialog(context);
      return;
    }
    pressed = !pressed;
    notifyers[widget.recipeId]!.value = pressed;
    var status;
    if (pressed) {
      Add();
    } else {
      Remove();
    }
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
    bool isFav = CollectionsInfo.favoriteRecipes![widget.recipeId] != null;
    // bool isFav = await FavoriteRecipesDbManager().isFavorite(widget.recipeId);
    print("((((((((isFav))))))))");
    // bool isFav = false;
    notifyers[widget.recipeId]!.value = isFav;
  }
}
