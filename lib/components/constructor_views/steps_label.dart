import 'package:flutter/material.dart';
import 'package:voice_recipe/components/timer/timer_decoration.dart';

import '../../config.dart';
import '../../model/dropped_file.dart';
import '../../model/recipes_info.dart';
import '../../screens/constructor/create_recipe_screen.dart';
import '../buttons/classic_button.dart';
import '../buttons/delete_button.dart';
import '../labels/time_label.dart';
import '../utils/drop_zone.dart';
import '../labels/input_label.dart';

class CreateStepsLabel extends StatefulWidget {
  const CreateStepsLabel({super.key, required this.insertList,
  required this.descFocusNode});

  final List<RecipeStep> insertList;
  final FocusNode descFocusNode;

  @override
  State<CreateStepsLabel> createState() => CreateStepsLabelState();
}

class CreateStepsLabelState extends State<CreateStepsLabel> {
  final stepController = TextEditingController();
  static CreateStepsLabelState? current;
  static TimeOfDay? stepTime;

  List<RecipeStep> get steps => widget.insertList;

  @override
  void initState() {
    current = this;
    super.initState();
  }

  @override
  void dispose() {
    current = null;
    stepController.dispose();
    super.dispose();
  }

    void clear() {
    if (current == null) return;
    stepTime = null;
    stepController.clear();
    widget.insertList.clear();
    setState(() {});
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              currentImageFile == null ? ImageDropZone(
                customButtonColor: CreateRecipeScreen.buttonColor,
                onDrop: handleDropFile,
                fontSize: CreateRecipeScreen.generalFontSize(context),
              ) : stepImagePreview(),
              const SizedBox(
                height: Config.padding,
              ),
              InputLabel(
                verticalExpand: true,
                withContentPadding: true,
                focusNode: widget.descFocusNode,
                labelText: "Описание шага",
                controller: stepController,
                fontSize: CreateRecipeScreen.generalFontSize(context),
                onSubmit: addNewStep,),
              const SizedBox(
                height: Config.padding,
              ),
              TimeLabel.buildSetter(context,
                  time: stepTime,
                  buttonText: "Указать время ожидания (опционально)",
                  labelText: "Время ожидания: ",
                  onSetTap: onStepTimeSet,
                  onDeleteTap: onClearStepTime),
              const SizedBox(
                height: Config.padding,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                    width: CreateRecipeScreen.pageWidth(context) * .5,
                    child: ClassicButton(
                      customColor: CreateRecipeScreen.buttonColor,onTap: addNewStep, text: "Добавить шаг",
                      fontSize: CreateRecipeScreen.generalFontSize(context),)
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  void onStepTimeSet() async {
    TimeOfDay initialTime =
    stepTime == null ? const TimeOfDay(hour: 0, minute: 0) : stepTime!;
    stepTime = await Config.showTimeInputDialog(
        context, "Время приготовления", initialTime);
    if (stepTime != null) {
      setState(() {});
    }
  }

  void onClearStepTime() {
    setState(() {
      stepTime = null;
    });
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
              crossAxisAlignment: CrossAxisAlignment.start,
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

  Widget stepImagePreview() {
    if (currentImageFile == null) {
      return Container();
    }
    return Container(
      margin: Config.paddingAll,
      child: Stack(
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
            margin: Config.paddingAll,
            child: DeleteButton(
                onPressed: () => setState(() => currentImageFile = null),
                toolTip: "Убрать изображение"
            )
          )
        ],
      ),
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
    if (desc.isEmpty) {
      Config.showAlertDialog("Описание не может быть пустым", context);
      return;
    }
    int waitTimeMins = 0;
    if (stepTime != null) {
      waitTimeMins = stepTime!.hour * 60 + stepTime!.minute;
    }
    stepController.clear();
    stepTime = null;
    setState(() {
      steps.add(RecipeStep(
          waitTime: waitTimeMins,
          id: steps.length + 1,
          imgUrl: currentImageFile!.url,
          description: desc));
      currentImageFile = null;
    });
  }
}