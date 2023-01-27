import 'package:flutter/material.dart';
import 'package:voice_recipe/components/buttons/classic_button.dart';
import 'package:voice_recipe/components/labels/time_label.dart';
import 'package:voice_recipe/components/utils/drop_zone.dart';
import 'package:voice_recipe/screens/account/login_screen.dart';

import '../../config.dart';
import '../../model/dropped_file.dart';
import '../../screens/constructor/create_recipe_screen.dart';
import '../buttons/delete_button.dart';
import '../labels/input_label.dart';

class CreateHeaderLabel extends StatefulWidget {
  const CreateHeaderLabel(
      {super.key, required this.headers, required this.nameFocusNode});

  final Map<HeaderField, dynamic> headers;
  final FocusNode nameFocusNode;

  @override
  State<CreateHeaderLabel> createState() => CreateHeaderLabelState();
}

class CreateHeaderLabelState extends State<CreateHeaderLabel> {
  final nameController = TextEditingController();
  static DroppedFile? currentImageFile;
  static CreateHeaderLabelState? current;
  static TimeOfDay? cookTime;
  static TimeOfDay? prepTime;

  @override
  void initState() {
    current = this;
    if (widget.headers.containsKey(HeaderField.name)) {
      nameController.text = widget.headers[HeaderField.name];
    }
    super.initState();
  }

  @override
  void dispose() {
    current = null;
    nameController.dispose();
    super.dispose();
  }

  void onDrop(DroppedFile file) {
    setState(() {
      widget.headers[HeaderField.faceImageUrl] = file.url;
      currentImageFile = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CreateRecipeScreen.title(context, "Основное"),
        const SizedBox(
          height: Config.padding,
        ),
        Container(
          padding: Config.paddingAll,
          width: CreateRecipeScreen.pageWidth(context) * .5,
          child: InputLabel(
            verticalExpand: true,
            withContentPadding: false,
            focusNode: widget.nameFocusNode,
            labelText: "Название рецепта",
            controller: nameController,
            fontSize: CreateRecipeScreen.generalFontSize(context),
            onSubmit: () {
              String name = nameController.text.trim();
              if (name.isEmpty) return;
              widget.headers[HeaderField.name] = name;
            },
          ),
        ),
        const SizedBox(
          height: Config.padding,
        ),
        Row(children: [
          Column(
            children: [
              Container(
                width: CreateRecipeScreen.pageWidth(context) * .5,
                margin: const EdgeInsets.only(left: Config.margin),
                alignment: Alignment.centerLeft,
                child: Text("Изображение для обложки",
                    style: TextStyle(
                        fontFamily: Config.fontFamily,
                        color: Config.iconColor,
                        fontSize: CreateRecipeScreen.titleFontSize(context))),
              ),
              const SizedBox(
                height: Config.padding,
              ),
              SizedBox(
                  width: CreateRecipeScreen.pageWidth(context) * .5,
                  child: currentImageFile == null
                      ? ImageDropZone(
                          customButtonColor: CreateRecipeScreen.buttonColor,
                          onDrop: onDrop,
                          fontSize: CreateRecipeScreen.generalFontSize(context))
                      : stepImagePreview()),
            ],
          ),
          Container(
            width: CreateRecipeScreen.pageWidth(context) * .4,
            alignment: Alignment.center,
            child: Column(
              children: [
                LoginScreen.voiceRecipeIcon(context, 150, 130),
                Text(
                  Config.appName,
                  style: TextStyle(
                      color: Config.iconColor,
                      fontFamily: Config.fontFamily,
                      fontSize: CreateRecipeScreen.titleFontSize(context)),
                )
              ],
            ),
          )
        ]),
        Container(
          margin: const EdgeInsets.only(left: Config.margin)
              .add(const EdgeInsets.only(top: Config.margin)),
          alignment: Alignment.centerLeft,
          child: Column(
            children: [
              TimeLabel.buildSetter(context,
                  time: cookTime,
                  buttonText: "Указать время приготовления",
                  labelText: "Время приготовления: ",
                  onSetTap: onCookTimeSet,
                  onDeleteTap: onClearCookTime),
              const SizedBox(
                height: Config.margin,
              ),
              TimeLabel.buildSetter(context,
                  time: prepTime,
                  buttonText: "Указать время подготовки (опционально)",
                  labelText: "Время подготовки: ",
                  onSetTap: onPrepTimeSet,
                  onDeleteTap: onClearPrepTime),
            ],
          ),
        ),
      ],
    );
  }

  void onCookTimeSet() async {
    TimeOfDay initialTime =
        cookTime == null ? const TimeOfDay(hour: 0, minute: 0) : cookTime!;
    cookTime = await Config.showTimeInputDialog(
        context, "Время приготовления", initialTime);
    if (cookTime != null) {
      setState(() {});
    }
  }

  void onClearCookTime() {
    setState(() {
      cookTime = null;
    });
  }

  void onPrepTimeSet() async {
    TimeOfDay initialTime =
        prepTime == null ? const TimeOfDay(hour: 0, minute: 0) : prepTime!;
    prepTime = await Config.showTimeInputDialog(
        context, "Время подготовки", initialTime);
    if (prepTime != null) {
      setState(() {});
    }
  }

  void onClearPrepTime() {
    setState(() {
      prepTime = null;
    });
  }

  TextStyle get textStyle => TextStyle(
      fontFamily: Config.fontFamily,
      color: Config.iconColor,
      fontSize: CreateRecipeScreen.generalFontSize(context));

  void clear() {
    currentImageFile = null;
    nameController.clear();
    cookTime = null;
    prepTime = null;
    widget.headers.remove(HeaderField.name);
    widget.headers.remove(HeaderField.faceImageUrl);
    widget.headers.remove(HeaderField.cookTimeMins);
    widget.headers.remove(HeaderField.prepTimeMins);
    if (current != null) {
      setState(() {});
    }
  }

  bool saveHeaders() {
    if (currentImageFile == null) {
      Config.showAlertDialog("Прикрепите изображение обложки", context);
      return false;
    }
    String recipeName = nameController.text.trim();
    if (recipeName.isEmpty) {
      Config.showAlertDialog("Введите название рецепта", context);
      return false;
    }
    if (cookTime == null) {
      Config.showAlertDialog(
          "Введите время приготовления (в минутах)", context);
      return false;
    }
    int cookTimeMinsFinal = cookTime!.hour * 60 + cookTime!.minute;
    int prepTimeMinsFinal = 0;
    if (prepTime != null) {
      prepTimeMinsFinal = prepTime!.hour * 60 + prepTime!.minute;
    }
    widget.headers[HeaderField.name] = recipeName;
    widget.headers[HeaderField.faceImageUrl] = currentImageFile!.url;
    widget.headers[HeaderField.cookTimeMins] = cookTimeMinsFinal;
    widget.headers[HeaderField.prepTimeMins] = prepTimeMinsFinal;
    return true;
  }

  Widget stepImagePreview() {
    if (currentImageFile == null) {
      return Container();
    }
    return Container(
      margin: Config.paddingAll,
      child: Stack(
        children: [
          SizedBox(
            child: ClipRRect(
                borderRadius: Config.borderRadiusLarge,
                child: Image(
                  image: NetworkImage(currentImageFile!.url),
                  fit: BoxFit.fitWidth,
                )),
          ),
          Container(
              alignment: Alignment.topRight,
              child: DeleteButton(
                  onPressed: () => setState(() {
                        if (currentImageFile == null) return;
                        widget.headers.remove(HeaderField.faceImageUrl);
                        currentImageFile = null;
                      }),
                  toolTip: "Убрать изображение"))
        ],
      ),
    );
  }
}
