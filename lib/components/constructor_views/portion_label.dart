import 'package:flutter/material.dart';

import '../../config/config.dart';
import '../../model/category_model.dart';
import '../../model/dialog/category_choice.dart';
import '../../model/recipes_info.dart';
import '../../model/sets_info.dart';
import '../../pages/constructor/create_recipe_page.dart';
import '../../services/db/category_db.dart';
import '../buttons/classic_button.dart';

class PortionLabel extends StatefulWidget {
  final void Function(int?) onChange;

  PortionLabel({required this.onChange});

  @override
  State<PortionLabel> createState() => PortionLabelState();
}

class PortionLabelState extends State<PortionLabel> {
  bool isEmpty = true;
  int selectedNumber = 1;

  static double widthConstraint(BuildContext context) {
    double resize = 1;
    if (Config.isDesktop(context)) {
      resize = .5;
    }
    return Config.constructorWidth(context) * resize;
  }


  void onSubmit(){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Выберите количество порций",
            style: TextStyle(
                fontFamily: Config.fontFamily,
                color: Config.iconColor,
                fontSize: CreateRecipePage.generalFontSize(context) * 1.5
            ),
          ),
          content: Container(
            height: 100,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.deepOrange.shade50,
              borderRadius: BorderRadius.circular(20)
            ),
            child: ListWheelScrollView(
              itemExtent: 50,
              diameterRatio: 1.5,
              physics: FixedExtentScrollPhysics(),
              perspective: 0.01,
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedNumber = index + 1; // Добавляем 1, так как индексы начинаются с 0
                  print(selectedNumber);
                });
              },
              children: List.generate(20, (index) {
                return Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(fontSize: 24),
                  ),
                );
              }),
            ),
          ),
          actions: [
            Container(
              alignment: Alignment.center,
              height: 60,
              padding: Config.paddingAll,
              child: SizedBox(
                width: 120,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      isEmpty = false;
                    });
                    widget.onChange(selectedNumber);
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange[300]!), // Set the background color
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set the text color
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0), // Set the border radius
                        // side: BorderSide(color: Colors.black), // Set the border color
                      ),
                    ),
                  ),
                  child: Text('Добавить'),
                ),
              ),
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CreateRecipePage.title(context, "Количество порций"),
        const SizedBox(
          height: Config.padding,
        ),
        isEmpty ?
        Container(
          padding: Config.paddingAll,
          child: Container(
            margin: Config.paddingAll,
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: CreateRecipePage.pageWidth(context),
              child: SizedBox(
                child: ClassicButton(
                  customColor: CreateRecipePage.buttonColor,
                  onTap: () {
                    onSubmit();
                  },
                  text: "Добавить количество порций",
                  fontSize: CreateRecipePage.generalFontSize(context),
                )
              )
            ),
          ),
        )
            :
        Container(
          height: 40,
          width: widthConstraint(context) * .85,
          decoration: BoxDecoration(
              color: CreateRecipePage.buttonColor.withOpacity(.9),
              borderRadius: Config.borderRadiusLarge
          ),
          padding: const EdgeInsets.symmetric(horizontal: Config.padding),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Количество порций: $selectedNumber",
                  style: TextStyle(
                      fontFamily: Config.fontFamily,
                      color: Config.iconColor,
                      fontSize: CreateRecipePage.generalFontSize(context)
                  ),
                ),
                IconButton(
                    onPressed: (){
                      setState(() {
                        isEmpty = true;
                        selectedNumber = 1;
                      });
                      widget.onChange(null);
                    },
                    icon: Icon(Icons.delete_outline)
                )
                // SizedBox(
                //   width: widthConstraint(context) * .4,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text(
                //         "$selectedNumber",
                //         style: TextStyle(
                //             fontFamily: Config.fontFamily,
                //             color: Config.iconColor,
                //             fontSize: CreateRecipePage.generalFontSize(context)
                //         ),)
                //       // TimeLabel(time: time),
                //       // const SizedBox(
                //       //   width: Config.margin / 2,
                //       // ),
                //       // DeleteButton(
                //       //     margin: const EdgeInsets.all(Config.margin * .2),
                //       //     onPressed: onDeleteTap)
                //     ],
                //   ),
                // )
              ]
          ),
        )
      ],
    );
  }



}