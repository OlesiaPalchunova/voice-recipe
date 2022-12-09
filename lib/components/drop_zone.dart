import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:voice_recipe/model/dropped_file.dart';

import '../config.dart';
import 'buttons/button.dart';

class DropZone extends StatefulWidget {
  const DropZone({super.key, required this.onDrop});

  final void Function(DroppedFile) onDrop;

  @override
  State<DropZone> createState() => _DropZoneState();
}

class _DropZoneState extends State<DropZone> {
  late DropzoneViewController dropController;
  bool highlighted = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: Config.borderRadiusLarge,
          color: highlighted ? Config.pressed : null),
      height: 200,
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
            color: Config.iconColor.withOpacity(.7),
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
                    style: TextStyle(
                        color: Config.iconColor,
                        fontFamily: Config.fontFamily,
                        fontSize: 18),
                  ),
                  const SizedBox(
                    height: Config.padding,
                  ),
                  SizedBox(
                      width: Config.recipeSlideWidth(context) * .3,
                      child: ClassicButton(
                          onTap: () async {
                            final events = await dropController.pickFiles();
                            if (events.isEmpty) return;
                            loadFile(events.first);
                          },
                          text: "Выбрать файл"))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future loadFile(dynamic file) async {
    final name = file.name;
    final mime = await dropController.getFileMIME(file);
    final size = await dropController.getFileSize(file);
    final url = await dropController.createFileUrl(file);
    widget.onDrop(DroppedFile(name: name, mime: mime, url: url, size: size));
    setState(() {
      highlighted = false;
    });
  }
}
