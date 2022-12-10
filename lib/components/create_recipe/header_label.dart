import 'package:flutter/cupertino.dart';
import 'package:voice_recipe/components/buttons/button.dart';
import 'package:voice_recipe/components/drop_zone.dart';

import '../../config.dart';
import '../../model/dropped_file.dart';
import '../../screens/create_recipe_screen.dart';
import '../buttons/delete_button.dart';
import '../login/input_label.dart';

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
  DroppedFile? currentImageFile;

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
        CreateRecipeScreen.title(context, "Название рецепта"),
        const SizedBox(
          height: Config.padding,
        ),
        Container(
          padding: Config.paddingAll,
          child: InputLabel(
            hintText: "Введите название рецепта",
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
        CreateRecipeScreen.title(context, "Изображение для обложки"),
        const SizedBox(
          height: Config.padding,
        ),
        Row(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                      width: CreateRecipeScreen.pageWidth(context) * .5,
                      child: currentImageFile == null
                      ? ImageDropZone(
                          onDrop: onDrop,
                          fontSize: CreateRecipeScreen.generalFontSize(context)
                        )
                      : stepImagePreview()
                  )
              ),
              const SizedBox(width: Config.margin,),
              SizedBox(
                width: CreateRecipeScreen.pageWidth(context) * .4,
                child: Column(
                  children: [
                    InputLabel(hintText: "Время приготовления, мин.", controller: cookTimeController,
                    fontSize: CreateRecipeScreen.generalFontSize(context) - 4,),
                    const SizedBox(height: Config.margin,),
                    InputLabel(hintText: "Время подготовки, мин. (опционально)", controller: prepTimeController,
                        fontSize: CreateRecipeScreen.generalFontSize(context) - 4),
                    const SizedBox(height: Config.margin * 2,),
                    ClassicButton(onTap: saveHeaders, text: "Сохранить",
                    fontSize: CreateRecipeScreen.generalFontSize(context),)
                  ],
                ),
              )
          ]
        )
      ],
    );
  }

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
      Config.showAlertDialog("Введите время приготовления (в минутах)", context);
      return;
    }
    int? cookTimeMins = int.tryParse(cookTimeMinsStr);
    if (cookTimeMins == null) {
      Config.showAlertDialog("Время приготовление должно быть числом (минут)", context);
      return;
    }
    String prepTimeMinStr = prepTimeController.text.trim();
    int? prepTimeMins;
    if (prepTimeMinStr.isNotEmpty) {
      prepTimeMins = int.tryParse(prepTimeMinStr);
      if (prepTimeMins == null) {
        Config.showAlertDialog("Время подготовки должно быть числом (минут)", context);
        return;
      }
    }
    int cookTimeMinsFinal = cookTimeMins;
    int prepTimeMinsFinal = prepTimeMins?? 0;
    widget.headers[HeaderField.name] = recipeName;
    widget.headers[HeaderField.faceImageUrl] = currentImageFile!.url;
    widget.headers[HeaderField.cookTimeMins] = cookTimeMinsFinal;
    widget.headers[HeaderField.prepTimeMins] = prepTimeMinsFinal;
    Config.showAlertDialog("Сохранено", context);
  }

  Widget stepImagePreview() {
    if (currentImageFile == null) {
      return Container();
    }
    return Stack(
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
    );
  }
}
