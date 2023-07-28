import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class DroppedFile {
  final String name;
  final String mime;
  final Uint8List bytes;
  final int size;

  DroppedFile({required this.name, required this.mime,
  required this.bytes, required this.size});


}
