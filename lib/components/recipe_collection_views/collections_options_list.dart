import 'package:flutter/material.dart';
import 'package:voice_recipe/components/recipe_collection_views/collection_option_tile.dart';
import 'package:voice_recipe/services/db/category_db.dart';

import '../../config/config.dart';
import '../../model/category.dart';
import '../../model/sets_info.dart';

class CollectionsOptionsList extends StatefulWidget {
  const CollectionsOptionsList({key, required this.set});

  final CollectionsSet set;

  @override
  State<CollectionsOptionsList> createState() => _CollectionsOptionsListState();
}

class _CollectionsOptionsListState extends State<CollectionsOptionsList> with SingleTickerProviderStateMixin {
  // late final _setOptions = widget.set.options;
  late final _setOptionsTemp;
  bool isLoaded = false;
  List<Collection> _setOptions = [Collection(id: 0, name: "45", collectionName: "46")];
  static const _initialDelayTime = Duration(milliseconds: 20);
  static const _itemSlideTime = Duration(milliseconds: 250);
  static const _staggerTime = Duration(milliseconds: 40);
  static const _buttonDelayTime = Duration(milliseconds: 150);
  static const _buttonTime = Duration(milliseconds: 300);
  late final _animationDuration = _initialDelayTime +
      (_staggerTime * _setOptions.length) +
      _buttonDelayTime +
      _buttonTime;

  late AnimationController _staggeredController;
  final List<Interval> _itemSlideIntervals = [];

  Future initOptions() async {
    _setOptionsTemp = await CategoryDB().getCategoriesOfSelections(selection_id: widget.set.id);
  }

  @override
  void initState() {
    super.initState();
    _initializeState().then((value) {
      setState(() {
        _setOptions = _setOptionsTemp;
        _createAnimationIntervals();
        isLoaded = true;
      });
    });

  }

  Future<void> _initializeState() async {
    await initOptions();
    // _createAnimationIntervals();
    _staggeredController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..forward();
  }


  void _createAnimationIntervals() {
    for (var i = 0; i < _setOptions.length; ++i) {
      final startTime = _initialDelayTime + (_staggerTime * i);
      final endTime = startTime + _itemSlideTime;
      _itemSlideIntervals.add(
        Interval(
          startTime.inMilliseconds / _animationDuration.inMilliseconds,
          endTime.inMilliseconds / _animationDuration.inMilliseconds,
        ),
      );
    }
  }

  @override
  void dispose() {
    _staggeredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listItems = <Widget>[];
    print(_setOptions);
    print("((_setOptions))");


    if (isLoaded){
      for (var i = 0; i < _setOptions.length; ++i) {
        print(i);
        listItems.add(
          Column(
            children: [
              AnimatedBuilder(
                animation: _staggeredController,
                builder: (context, child) {
                  final animationPercent = Curves.easeOut.transform(
                    _itemSlideIntervals[i]
                        .transform(_staggeredController.value),
                  );
                  final opacity = animationPercent;
                  final slideDistance = (1.0 - animationPercent) * 150;
                  return Opacity(
                    opacity: opacity,
                    child: Transform.translate(
                      offset: Offset(slideDistance, 0),
                      child: child,
                    ),
                  );
                },
                child: CollectionOptionTile(
                  setOption: _setOptions[i],
                ),
              ),
            ],
          ),
        );
      }
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(0, Config.margin, 0, 0),
      child: Column(
        children: listItems,
      ),
    );
  }
}