import 'package:flutter/material.dart';
import 'package:voice_recipe/components/timer/timer_decoration.dart';

import '../../config.dart';
import '../../model/dropped_file.dart';
import '../../model/recipes_info.dart';
import '../../screens/create_recipe_screen.dart';
import '../buttons/button.dart';
import '../buttons/delete_button.dart';
import '../drop_zone.dart';
import '../login/input_label.dart';

class StepsLabel extends StatefulWidget {
  const StepsLabel({super.key, required this.insertList});

  final List<RecipeStep> insertList;

  @override
  State<StepsLabel> createState() => _StepsLabelState();
}

class _StepsLabelState extends State<StepsLabel> {
  final stepController = TextEditingController();
  final waitTimeController = TextEditingController();

  List<RecipeStep> get steps => widget.insertList;

  @override
  void dispose() {
    stepController.dispose();
    waitTimeController.dispose();
    super.dispose();
  }

  Widget buildStep(RecipeStep step) {
    return Stack(
      children: [
        Container(
            decoration: BoxDecoration(
                color: Config.darkModeOn ?
                Config.backgroundColor : Config.pressed,
                borderRadius: Config.borderRadiusLarge
            ),
            padding: Config.paddingAll,
            margin: const EdgeInsets.only(bottom: Config.margin),
            child: Column(
              children: [
                ClipRRect(
                    borderRadius: Config.borderRadiusLarge,
                    child: Image(
                      image: NetworkImage(step.imgUrl),
                      fit: BoxFit.fitWidth,
                    )),
                const SizedBox(
                  height: Config.padding,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: Config.padding),
                      child: Text(
                        "Шаг ${step.id}",
                        style: TextStyle(
                            color: Config.iconColor,
                            fontFamily: Config.fontFamily,
                            fontSize: 18
                        ),
                      ),
                    ),
                    step.waitTime == 0 ? Container()
                        : Container(
                        margin: Config.paddingAll,
                        alignment: Alignment.center,
                        width: CreateRecipeScreen.pageWidth(context) * .5,
                        height: 50,
                        child: TimerDecoration(waitTime: Duration(minutes: step.waitTime)
                        )
                    )
                  ],
                ),
                const SizedBox(
                  height: Config.padding,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: !Config.darkModeOn ? Colors.black87.withOpacity(.75)
                          : Config.iconBackColor,
                      borderRadius: Config.borderRadiusLarge),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(Config.padding),
                  child: Text(
                    step.description,
                    style: const TextStyle(
                        fontFamily: Config.fontFamily,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: Config.margin,),
              ],
            )
        ),
        Container(
            alignment: Alignment.topRight,
            child: DeleteButton(
                onPressed: () => setState(() {
                  for (RecipeStep other in steps) {
                    if (other.id > step.id) {
                      other.id--;
                    }
                  }
                  steps.remove(step);
                }),
                toolTip: "Удалить шаг"
            )
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CreateRecipeScreen.title(context, "Шаги"),
        const SizedBox(
          height: Config.padding,
        ),
        Container(
          padding: Config.paddingAll,
          child: Column(
            children: steps.map(buildStep).toList(),
          ),
        ),
        CreateRecipeScreen.title(context, "Изображение для шага"),
        Container(
          padding: Config.paddingAll,
          child: Column(
            children: [
              currentImageFile == null ? ImageDropZone(
                onDrop: handleDropFile,
                fontSize: CreateRecipeScreen.generalFontSize(context),
              ) : stepImagePreview(),
              const SizedBox(
                height: Config.padding,
              ),
              InputLabel(
                  hintText: "Введите описание шага",
                  controller: stepController,
                fontSize: CreateRecipeScreen.generalFontSize(context),),
              const SizedBox(
                height: Config.padding,
              ),
              InputLabel(
                  hintText: "Время ожидания, мин. (опционально)",
                  controller: waitTimeController,
                fontSize: CreateRecipeScreen.generalFontSize(context),),
              const SizedBox(
                height: Config.padding,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                    width: CreateRecipeScreen.pageWidth(context) * .5,
                    child: ClassicButton(onTap: addNewStep, text: "Добавить шаг",
                      fontSize: CreateRecipeScreen.generalFontSize(context),)
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget stepImagePreview() {
    if (currentImageFile == null) {
      return Container();
    }
    return Stack(
      children: [
        ClipRRect(
            borderRadius: Config.borderRadiusLarge,
            child: Image(
              image: NetworkImage(currentImageFile!.url),
              fit: BoxFit.fitWidth,
            )
        ),
        Container(
          alignment: Alignment.topRight,
          child: DeleteButton(
              onPressed: () => setState(() => currentImageFile = null),
              toolTip: "Убрать изображение"
          )
        )
      ],
    );
  }


  DroppedFile? currentImageFile;

  void handleDropFile(DroppedFile file) {
    setState(() {
      currentImageFile = file;
    });
  }

  void addNewStep() {
    if (currentImageFile == null) {
      Config.showAlertDialog(
          "К шагу должно быть приложено изображение", context);
      return;
    }
    String desc = stepController.text.trim();
    String waitTimeStr = waitTimeController.text.trim();
    if (desc.isEmpty) {
      Config.showAlertDialog("Описание не может быть пустым", context);
      return;
    }
    int waitTimeFinal = 0;
    if (waitTimeStr.isNotEmpty) {
      int? waitTime = int.tryParse(waitTimeStr);
      if (waitTime == null) {
        Config.showAlertDialog(
            "Время ожидания должно быть числом (минут)", context);
        return;
      }
      if (waitTime > 24 * 60) {
        Config.showAlertDialog(
            "Время ожидания не может превышать сутки", context);
        return;
      }
      waitTimeFinal = waitTime;
    }
    stepController.clear();
    waitTimeController.clear();
    setState(() {
      steps.add(RecipeStep(
          waitTime: waitTimeFinal,
          id: steps.length + 1,
          imgUrl: currentImageFile!.url,
          description: desc));
      currentImageFile = null;
    });
  }
}