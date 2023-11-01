import 'package:flutter/material.dart';
import 'package:voice_recipe/components/recipe_collection_views/collections_options_list.dart';

import 'package:voice_recipe/config/config.dart';
import 'package:voice_recipe/model/sets_info.dart';

class CollectionHeaderCard extends StatefulWidget {
  const CollectionHeaderCard(
      {Key? key,
      required this.set,
      required this.onTap,
      this.widthConstraint = 0,
      this.hasSubtitles = true})
      : super(key: key);

  final VoidCallback onTap;
  final CollectionsSet set;
  final double widthConstraint;
  final bool hasSubtitles;

  @override
  State<CollectionHeaderCard> createState() => _CollectionHeaderCardState();
}

class _CollectionHeaderCardState extends State<CollectionHeaderCard>
    with SingleTickerProviderStateMixin {
  bool pressed = false;
  bool hovered = false;
  bool disposed = false;

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  bool get active => hovered;

  @override
  Widget build(BuildContext context) {
    double cardHeight = Config.pageHeight(context) / 10;
    final width = widget.widthConstraint > 0
        ? widget.widthConstraint
        : Config.recipeSlideWidth(context);
    return InkWell(
      borderRadius: Config.borderRadius,
      onHover: (h) => setState(() {
        hovered = h;
      }),
      onTap: () async {
        setState(() {
          widget.onTap();
          pressed = !pressed;
        });
        if (widget.hasSubtitles | !pressed) {
          return;
        }
        await Future.delayed(Config.shortAnimationTime).whenComplete(() {
          if (disposed) return;
          setState(() {
            pressed = false;
          });
        });
      },
      child: Column(
        children: [
          Card(
            elevation: 3,
            color: Colors.white.withOpacity(0),
            margin: const EdgeInsets.symmetric(vertical: Config.margin / 2),
            child: Column(
              children: [
                Stack(children: [
                  SizedBox(
                    child: AnimatedContainer(
                      duration: Config.animationTime,
                      height: cardHeight,
                      decoration: BoxDecoration(
                          borderRadius: Config.borderRadius,
                          color: active
                              ? Config.activeBackgroundLightedColor
                              : Config.backgroundLightedColor),
                      child: Row(
                        children: [
                          SizedBox(
                            width: width * 0.5,
                          ),
                          // Container(
                          //   width: width * 0.4,
                          //   alignment: Alignment.center,
                          //   child: Image(
                          //     image: AssetImage(widget.set.imageUrl),
                          //     height: active ? cardHeight : cardHeight * 0.9,
                          //     // fit: BoxFit.fitWidth,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 300,
                    height: cardHeight,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: Config.padding),
                    child: Text(widget.set.name,
                        style: TextStyle(
                            fontFamily: Config.fontFamily,
                            fontSize:
                                !active ? fontSize(context) : fontSize(context) + 2,
                            color: Config.iconColor)),
                  ),
                ]),

              ],
            ),
          ),
          pressed & widget.hasSubtitles
              ? CollectionsOptionsList(set: widget.set)
              : const SizedBox(),
        ],
      ),
    );
  }

  double fontSize(BuildContext context) => Config.isDesktop(context) ? 22 : 20;
}
