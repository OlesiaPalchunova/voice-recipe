import 'package:flutter/cupertino.dart';
import 'package:voice_recipe/components/buttons/classic_button.dart';
import 'package:voice_recipe/components/drop_zone.dart';
import 'package:voice_recipe/screens/authorization/login_screen.dart';

import '../../config.dart';
import '../../model/dropped_file.dart';
import '../../screens/create_recipe_screen.dart';
import '../buttons/delete_button.dart';
import '../labels/input_label.dart';

class HeaderLabel extends StatefulWidget {
  const HeaderLabel({super.key, required this.headers});

  final Map<HeaderField, dynamic> headers;

  @override
  State<HeaderLabel> createState() => _HeaderLabelState();
}

class _HeaderLabelState extends State<HeaderLabel> {
  final nameController = TextEditingController();
  final cookTimeController = TextEditingController();
  final prepTimeController = TextEditingController();
  static DroppedFile? currentImageFile;

  @override
  void initState() {
    if (widget.headers.containsKey(HeaderField.name)) {
      nameController.text = widget.headers[HeaderField.name];
    }
    if (widget.headers.containsKey(HeaderField.cookTimeMins)) {
      cookTimeController.text =
          widget.headers[HeaderField.cookTimeMins].toString();
    }
    if (widget.headers.containsKey(HeaderField.prepTimeMins)) {
      if (widget.headers[HeaderField.prepTimeMins] > 0) {
        prepTimeController.text =
            widget.headers[HeaderField.prepTimeMins].toString();
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    cookTimeController.dispose();
    prepTimeController.dispose();
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
      children: [
        CreateRecipeScreen.title(context, "Основное"),
        const SizedBox(
          height: Config.padding,
        ),
        Container(
          padding: Config.paddingAll,
          child: InputLabel(
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
                          fontSize: CreateRecipeScreen.titleFontSize(context)
                      )
                  ),
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
              SizedBox(
                // width: CreateRecipeScreen.pageWidth(context) * .7,
                child: InputLabel(
                  labelText: "Время приготовления, в минутах",
                  controller: cookTimeController,
                  fontSize: CreateRecipeScreen.generalFontSize(context),
                  onSubmit: saveHeaders,
                ),
              ),
              const SizedBox(
                height: Config.margin,
              ),
              SizedBox(
                // width: CreateRecipeScreen.pageWidth(context) * .7,
                child: InputLabel(
                    labelText: "Время подготовки, в минутах (необязательно)",
                    controller: prepTimeController,
                    fontSize: CreateRecipeScreen.generalFontSize(context),
                    onSubmit: saveHeaders),
              ),
              const SizedBox(
                height: Config.margin,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                    width: CreateRecipeScreen.pageWidth(context) * .5,
                    child: ClassicButton(
                      customColor: CreateRecipeScreen.buttonColor,
                      onTap: saveHeaders,
                      text: "Сохранить",
                      fontSize: CreateRecipeScreen.generalFontSize(context),
                    )),
              )
            ],
          ),
        ),
      ],
    );
  }

  TextStyle get textStyle => TextStyle(
      fontFamily: Config.fontFamily,
      color: Config.iconColor,
      fontSize: CreateRecipeScreen.generalFontSize(context));

  void saveHeaders() {
    if (currentImageFile == null) {
      Config.showAlertDialog("Прикрепите изображение обложки", context);
      return;
    }
    String recipeName = nameController.text.trim();
    if (recipeName.isEmpty) {
      Config.showAlertDialog("Введите название рецепта", context);
      return;
    }
    String cookTimeMinsStr = cookTimeController.text.trim();
    if (cookTimeMinsStr.isEmpty) {
      Config.showAlertDialog(
          "Введите время приготовления (в минутах)", context);
      return;
    }
    int? cookTimeMins = int.tryParse(cookTimeMinsStr);
    if (cookTimeMins == null) {
      Config.showAlertDialog(
          "Время приготовление должно быть числом (минут)", context);
      return;
    }
    String prepTimeMinStr = prepTimeController.text.trim();
    int? prepTimeMins;
    if (prepTimeMinStr.isNotEmpty) {
      prepTimeMins = int.tryParse(prepTimeMinStr);
      if (prepTimeMins == null) {
        Config.showAlertDialog(
            "Время подготовки должно быть числом (минут)", context);
        return;
      }
    }
    int cookTimeMinsFinal = cookTimeMins;
    int prepTimeMinsFinal = prepTimeMins ?? 0;
    widget.headers[HeaderField.name] = recipeName;
    widget.headers[HeaderField.faceImageUrl] = currentImageFile!.url;
    widget.headers[HeaderField.cookTimeMins] = cookTimeMinsFinal;
    widget.headers[HeaderField.prepTimeMins] = prepTimeMinsFinal;
    Config.showAlertDialog("Готово, не забудьте сохранить рецепт внизу", context);
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