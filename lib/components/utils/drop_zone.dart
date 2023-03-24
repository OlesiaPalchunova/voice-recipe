import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:voice_recipe/model/dropped_file.dart';
import 'package:voice_recipe/services/service_io.dart';

import '../../config/config.dart';
import '../buttons/classic_button.dart';
import 'package:file_picker/file_picker.dart';

class ImageDropZone extends StatefulWidget {
  const ImageDropZone(
      {super.key,
      required this.onDrop,
      this.fontSize = 18,
      this.customButtonColor});

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
        height: Config.isDesktop(context) ? 300 : 200,
        padding: Config.paddingAll,
        child:
            Config.isWeb ? buildWebView(context) : buildPortableView(context));
  }

  Widget buildPortableView(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Config.backgroundEdgeColor,
            borderRadius: Config.borderRadiusLarge),
        alignment: Alignment.center,
        child: SizedBox(
          width: Config.recipeSlideWidth(context) * .4,
          height: 50,
          child: ClassicButton(
            customColor: widget.customButtonColor,
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                withData: true,
                allowedExtensions: ['jpg', 'jpeg', 'png'],
              );
              if (result == null) return;
              var file = result.files.first;
              print(result.files.first.path);

              widget.onDrop(DroppedFile(
                  name: file.name,
                  mime: "image/${file.extension}",
                  bytes: file.bytes!,
                  size: file.size));
            },
            text: "Выбрать файл",
            fontSize: widget.fontSize,
          ),
        ));
  }

  Widget buildWebView(BuildContext context) {
    return Stack(
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
            decoration: BoxDecoration(
                borderRadius: Config.borderRadiusLarge,
                boxShadow: [
                  BoxShadow(
                      color: Config.darkModeOn
                          ? Colors.black87.withOpacity(.2)
                          : Colors.white.withOpacity(.2),
                      spreadRadius: 0.5)
                ]),
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
                      fontSize: widget.fontSize,
                    ))
              ],
            ),
          ),
        ),
      ],
    );
  }

  static const allowedMimes = ["image/jpeg", "image/jpg", "image/png"];

  Future loadFile(dynamic file) async {
    final name = file.name;
    final mime = await dropController.getFileMIME(file);
    final size = await dropController.getFileSize(file);
    final bytes = await dropController.getFileData(file);
    setState(() {
      highlighted = false;
    });
    if (!allowedMimes.contains(mime)) {
      Future.microtask(() => ServiceIO.showAlertDialog(
          "Допустимые форматы: jpeg, jpg, png", context));
      return;
    }
    widget
        .onDrop(DroppedFile(name: name, mime: mime, bytes: bytes, size: size));
  }
}
