import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:voice_recipe/components/recipe_header_card.dart';

import '../../config/config.dart';

import 'package:rive/rive.dart';

import '../../model/recipes_info.dart';
import '../../services/db/rate_db.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../services/db/user_db.dart';
import '../../services/service_io.dart';

class StarPanel extends StatefulWidget {
  StarPanel({
    Key? key,
    required this.id,
    required this.onTap,
    required this.rate,
    required this.recipe,
  }) : super(key: key);

  final int id;
  final Function(int) onTap;
  final int rate;
  Recipe recipe;

  @override
  State<StarPanel> createState() => StarPanelState();
}

class StarPanelState extends State<StarPanel> {
  late int currentRate;
  static const starsCount = 5;
  static StarPanelState? current;
  static final starsTable = HashMap<int, int>();

  StateMachineController? controller;
  SMIInput<double>? inputValue;

  static int rate = 0;

  Future initRate() async {
    int rate1 = await RateDbManager().getMarkById(widget.id, "lesia");
    setState(() {
      _initialRating = rate1;
      print(":(((((((((((((((");
      print(rate);
    });
  }

  @override
  void initState() {
    initRate();
    print("55555555555555");
    print(widget.rate);
    current = this;
    currentRate = starsTable[widget.id] ?? 1;
    print("rrrrrrrrrrrrrrr $currentRate");
    // _initialRating = widget.rate;
    super.initState();
  }

  @override
  void dispose() {
    starsTable[widget.id] = currentRate;
    super.dispose();
  }

  void clear() {
  }

  int getRate(String stateName) {
    if (stateName == "1_star") return 1;
    if (stateName == "2_stars") return 2;
    if (stateName == "3_stars") return 3;
    if (stateName == "4_stars") return 4;
    if (stateName == "5_stars") return 5;
    return 0;
  }

  String getState(int rate) {
    if (rate == 1) return "1_star";
    if (rate == 2) return "2_stars";
    if (rate == 3) return "3_stars";
    if (rate == 4) return "4_stars";
    if (rate == 5) return "5_stars";
    print("oooooooooooooo");
    print(rate);
    return " ";
  }

  String get postfix => Config.darkModeOn ? "" : "_light";

  int _initialRating = 0;

  void _resetRating() {
    print("hhhh");
    setState(() {
      print("hhhh");
      _initialRating = 0;
      print("hhhh");
    });
  }

  var isSet = false;


  @override
  Widget build(BuildContext context) {
    double k = Config.isDesktop(context) ? .5 : .6;
    final width = Config.loginPageWidth(context) * k;
    return InkWell(
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [RatingBar.builder(
          initialRating: _initialRating.toDouble(),
          direction: Axis.horizontal,
          allowHalfRating: false,
          itemCount: 5,
          itemSize: 40.0,
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            if (_initialRating == 0) {
              RateDbManager().addNewMark(recipeId: widget.id, userUid: UserDB.uid, mark: rating.toInt());
              initRate();
              if (!ServiceIO.loggedIn) {
                ServiceIO.showMarkInviteDialog(context);
              }
            } else {
            RateDbManager().updateMark(id: 0, userUid: UserDB.uid ?? "", recipeId:  widget.id, mark: rating);
            if (!ServiceIO.loggedIn) {
              ServiceIO.showMarkInviteDialog(context);
            }
          }
            _initialRating = rating.toInt();
          },
        ),
          SizedBox(width: 20),
          ElevatedButton(
            onPressed:() {
              var log = ServiceIO.loggedIn;
              print("log: $log");
              if (!ServiceIO.loggedIn) ServiceIO.showMarkInviteDialog(context);
              RateDbManager().deleteMark(widget.id);
              setState(() {
                _initialRating = 0;
              });
            },
            child: Text('Убрать'),
          ),
      ]

      )
    );
  }

}
