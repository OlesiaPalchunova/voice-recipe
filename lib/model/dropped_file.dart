import 'dart:typed_data';

class DroppedFile {
  final String name;
  final String mime;
  final Uint8List bytes;
  final int size;

  DroppedFile({required this.name, required this.mime,
  required this.bytes, required this.size});
}
