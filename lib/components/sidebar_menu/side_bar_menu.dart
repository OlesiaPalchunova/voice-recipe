import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:voice_recipe/config.dart';
import 'package:voice_recipe/screens/sets_list_screen.dart';

class SideBarMenu extends StatefulWidget {
  const SideBarMenu({super.key, required this.onUpdate});
  final VoidCallback onUpdate;

  @override
  State<SideBarMenu> createState() => _SideBarMenuState();

  static Widget buildHeader({
    required String name,
    required VoidCallback onClicked,
    required IconData iconData
  }) => InkWell(
    onTap: onClicked,
    child: Row(
      children: [
        Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: Config.darkModeOn ? Colors.orangeAccent
                      : Colors.orangeAccent
              )
          ),
          child: CircleAvatar(
            radius: 22,
            backgroundColor: Config.backgroundColor(),
            child: Icon(
              iconData,
              color: Config.iconColor(),
              size: 26,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Text(
          name,
          style: TextStyle(fontSize: 20, color: Config.iconColor(),
            fontFamily: Config.fontFamily,),
        ),
      ],
    ),
  );
}

class _SideBarMenuState extends State<SideBarMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: min(Config.pageWidth(context) * 0.7, 400),
      child: Material(
          color: Config.backgroundColor(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(Config.padding),
                child: Column(
                  children: [
                    SizedBox(height: Config.pageHeight(context) / 7,),
                    // const Divider(
                    //   color: Colors.white,
                    // ),
                    SideBarMenu.buildHeader(
                      name: "Подборки",
                      onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SetsListScreen(),
                      )),
                      iconData: Config.darkModeOn ? Icons.library_books_rounded
                                                  : Icons.library_books_outlined
                    ),
                    Divider(
                      color: Config.iconColor(),
                    ),
                    SideBarMenu.buildHeader(
                        name: "Голосовые\nкоманды",
                        onClicked: () {
                        },
                        iconData: Config.darkModeOn ? Icons.record_voice_over_rounded
                            : Icons.record_voice_over_outlined
                    ),
                    Divider(
                      color: Config.iconColor(),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(Config.margin, Config.margin,
                    Config.margin, Config.margin * 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Тёмная тема",
                      style: TextStyle(
                          fontFamily: Config.fontFamily,
                          color:
                              Config.darkModeOn ? Colors.white : Colors.black87,
                          fontSize: 16),
                    ),
                    CupertinoSwitch(
                      value: Config.darkModeOn,
                      onChanged: (value) {
                        setState(() {
                          widget.onUpdate();
                          Config.setDarkModeOn(!Config.darkModeOn);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
