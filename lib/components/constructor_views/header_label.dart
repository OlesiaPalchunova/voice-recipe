import 'package:flutter/material.dart';
import 'package:voice_recipe/components/labels/time_label.dart';
import 'package:voice_recipe/components/utils/drop_zone.dart';
import 'package:voice_recipe/pages/account/login_page.dart';
import 'package:voice_recipe/services/service_io.dart';

import '../../config/config.dart';
import '../../model/dropped_file.dart';
import '../../pages/constructor/create_recipe_page.dart';
import '../buttons/delete_button.dart';
import '../labels/input_label.dart';

class CreateHeaderLabel extends StatefulWidget {
  const CreateHeaderLabel(
      {key, required this.headers, required this.nameFocusNode});

  final HeaderInfo headers;
  final FocusNode nameFocusNode;

  @override
  State<CreateHeaderLabel> createState() => CreateHeaderLabelState();
}

class HeaderInfo {
  String? name;
  String? userUid;
  int? cookTimeMins;
  int? prepTimeMins;
  DroppedFile? faceImageRaw;
  String? faceImageUrl;
}

class CreateHeaderLabelState extends State<CreateHeaderLabel> {
  final nameController = TextEditingController();
  static DroppedFile? currentImageFile;
  static CreateHeaderLabelState? current;
  static TimeOfDay? cookTime;
  static TimeOfDay? prepTime;

  HeaderInfo get headers => widget.headers;

  @override
  void initState() {
    current = this;
    if (headers.name != null) {
      nameController.text = headers.name!;
    }
    if (headers.faceImageRaw != null) {
      currentImageFile = headers.faceImageRaw;
    }
    if (headers.cookTimeMins != null) {
      int totalMins = headers.cookTimeMins!;
      int mins = totalMins % 60;
      int hours = (totalMins - mins) ~/ 60;
      cookTime = TimeOfDay(hour: hours, minute: mins);
    }
    if (headers.prepTimeMins != null) {
      int totalMins = headers.prepTimeMins!;
      int mins = totalMins % 60;
      int hours = (totalMins - mins) ~/ 60;
      prepTime = TimeOfDay(hour: hours, minute: mins);
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
      headers.faceImageRaw = file;
      currentImageFile = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CreateRecipePage.title(context, "Основное"),
        const SizedBox(
          height: Config.padding,
        ),
        Container(
          padding: Config.paddingAll,
          width: CreateRecipePage.pageWidth(context) * .5,
          child: InputLabel(
            verticalExpand: true,
            withContentPadding: false,
            focusNode: widget.nameFocusNode,
            labelText: "Название рецепта",
            controller: nameController,
            fontSize: CreateRecipePage.generalFontSize(context),
            onSubmit: () {
              String name = nameController.text.trim();
              if (name.isEmpty) return;
              headers.name = name;
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
                width: CreateRecipePage.pageWidth(context) * .5,
                margin: const EdgeInsets.only(left: Config.margin),
                alignment: Alignment.centerLeft,
                child: Text("Изображение для обложки",
                    style: TextStyle(
                        fontFamily: Config.fontFamily,
                        color: Config.iconColor,
                        fontSize: CreateRecipePage.titleFontSize(context))),
              ),
              const SizedBox(
                height: Config.padding,
              ),
              SizedBox(
                  width: CreateRecipePage.pageWidth(context) * .5,
                  child: currentImageFile == null && headers.faceImageUrl == null
                      ? ImageDropZone(
                          customButtonColor: CreateRecipePage.buttonColor,
                          onDrop: onDrop,
                          fontSize: 13)
                      : stepImagePreview()
              ),
            ],
          ),
          Container(
            width: CreateRecipePage.pageWidth(context) * .4,
            alignment: Alignment.center,
            child: Column(
              children: [
                LoginPage.voiceRecipeIcon(context, 150, 130),
                Text(
                  Config.appName,
                  style: TextStyle(
                      color: Config.iconColor,
                      fontFamily: Config.fontFamily,
                      fontSize: CreateRecipePage.titleFontSize(context)),
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
    cookTime = await ServiceIO.showTimeInputDialog(
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
    prepTime = await ServiceIO.showTimeInputDialog(
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
      fontSize: CreateRecipePage.generalFontSize(context));

  void clear() {
    currentImageFile = null;
    nameController.clear();
    cookTime = null;
    prepTime = null;
    headers.name = null;
    headers.faceImageRaw = null;
    headers.cookTimeMins = null;
    headers.prepTimeMins = null;
    if (current != null) {
      setState(() {});
    }
  }

  bool saveHeaders() {
    if (currentImageFile == null) {
      ServiceIO.showAlertDialog("Прикрепите изображение обложки", context);
      return false;
    }
    String recipeName = nameController.text.trim();
    if (recipeName.isEmpty) {
      ServiceIO.showAlertDialog("Введите название рецепта", context);
      return false;
    }
    if (cookTime == null) {
      ServiceIO.showAlertDialog(
          "Введите время приготовления (в минутах)", context);
      return false;
    }
    int cookTimeMinsFinal = cookTime!.hour * 60 + cookTime!.minute;
    int prepTimeMinsFinal = 0;
    if (prepTime != null) {
      prepTimeMinsFinal = prepTime!.hour * 60 + prepTime!.minute;
    }
    headers.name = recipeName;
    headers.faceImageRaw = currentImageFile!;
    headers.cookTimeMins = cookTimeMinsFinal;
    headers.prepTimeMins = prepTimeMinsFinal;
    return true;
  }

  Widget stepImagePreview() {
    if (currentImageFile == null && headers.faceImageUrl == null) {
      return Container();
    }
    return Container(
      margin: Config.paddingAll,
      child: Stack(
        children: [
          SizedBox(
            child: ClipRRect(
              borderRadius: Config.borderRadiusLarge,
              child: headers.faceImageUrl == null
                  ? Image.memory(
                      currentImageFile!.bytes,
                      fit: BoxFit.fitWidth,
                    )
                  : Image.network(
                      headers.faceImageUrl!,
                      fit: BoxFit.fitWidth,
                    ),
            ),
          ),
          Container(
              alignment: Alignment.topRight,
              child: DeleteButton(
                  onPressed: () => setState(() {
                        if (currentImageFile == null) return;
                        headers.faceImageRaw = null;
                        currentImageFile = null;
                      }),
                  toolTip: "Убрать изображение"))
        ],
      ),
    );
  }
}
