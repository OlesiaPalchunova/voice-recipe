import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:voice_recipe/model/dropped_file.dart';

import '../config.dart';
import 'buttons/classic_button.dart';

class ImageDropZone extends StatefulWidget {
  const ImageDropZone({super.key, required this.onDrop,
  this.fontSize = 18, this.customButtonColor});

  final Color? customButtonColor;
  final void Function(DroppedFile) onDrop;
  final double fontSize;

  @override
  State<ImageDropZone> createState() => _ImageDropZoneState();
}

class _ImageDropZoneState extends State<ImageDropZone> {
  late DropzoneViewController dropController;
  bool highlighted = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: Config.borderRadiusLarge,
          color: highlighted ? ClassicButton.hoverColor : null),
      height: 300,
      padding: Config.paddingAll,
      child: Stack(
        children: [
          DropzoneView(
            onDrop: loadFile,
            onCreated: (controller) => dropController = controller,
            onHover: () => setState(() => highlighted = true),
            onLeave: () => setState(() => highlighted = false),
          ),
          DottedBorder(
            borderType: BorderType.RRect,
            color: Config.iconColor.withOpacity(.5),
            strokeWidth: 3,
            radius: const Radius.circular(Config.largeRadius),
            dashPattern: const [8, 4],
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload,
                    color: Config.iconColor,
                    size: 40,
                  ),
                  Text(
                    "Перетащите изображение сюда",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Config.iconColor,
                        fontFamily: Config.fontFamily,
                        fontSize: widget.fontSize),
                  ),
                  const SizedBox(
                    height: Config.padding,
                  ),
                  SizedBox(
                      width: Config.recipeSlideWidth(context) * .4,
                      child: ClassicButton(
                        customColor: widget.customButtonColor,
                          onTap: () async {
                            final events = await dropController.pickFiles();
                            if (events.isEmpty) return;
                            loadFile(events.first);
                          },
                          text: "Выбрать файл",
                          fontSize: widget.fontSize,))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const allowedMimes = ["image/jpeg", "image/jpg", "image/png"];

  Future loadFile(dynamic file) async {
    final name = file.name;
    final mime = await dropController.getFileMIME(file);
    final size = await dropController.getFileSize(file);
    final url = await dropController.createFileUrl(file);
    setState(() {
      highlighted = false;
    });
    if (!allowedMimes.contains(mime)) {
      Future.microtask(() => Config.showAlertDialog("Допустимые форматы: jpeg, jpg, png", context));
      return;
    }
    widget.onDrop(DroppedFile(name: name, mime: mime, url: url, size: size));
  }
}
