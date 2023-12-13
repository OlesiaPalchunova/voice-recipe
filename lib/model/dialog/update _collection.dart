import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/utils/animated_loading.dart';
import '../../services/db/collection_db.dart';
import '../../services/service_io.dart';
import '../collection.dart';
import '../../model/dropped_file.dart';

class UpdateCollection extends StatefulWidget {
  UpdateCollection({required this.onInit, required this.text, required this.imageUrl, required this.id});
  final void Function() onInit;
  String text;
  String? imageUrl;
  int id = 0;

  @override
  State<UpdateCollection> createState() => _UpdateCollectionState();
}

class _UpdateCollectionState extends State<UpdateCollection> {

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.text;
    super.initState();
  }

  var imageFile;
  var pickedFile;
  static DroppedFile? dropped_image;
  File? _imageFile;
  static Collection collection = Collection(id: 0, name: "null", imageUrl: "null", count: 0);

  bool isEditing() => widget.imageUrl != null;


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        content: SingleChildScrollView(
          child: Container(
            height: 300,
            child: Column(
              children: [
                SizedBox(
                  height: 70,
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Название коллекции',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        // borderSide: BorderSide(color: Colors.blue, width: 0.0),
                      ),
                    ),
                  ),
                ),
                Container(
                    width: 230,
                    height: 230,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.deepOrange[100]
                    ),
                    child:  addImage()
                )
              ],
            ),
          ),
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              onPressed: () async {
                int status;
                if (isEditing()) {
                  status = await CollectionDB.updateCollection(
                      id: widget.id,
                      imageFile: dropped_image,
                      collection: collection,
                      name: _controller.text,
                      imageUrl: widget.imageUrl!
                  );
                }
                else {
                  status = await CollectionDB.addCollection(
                      imageFile: dropped_image,
                      collection: collection,
                      name: _controller.text
                  );
                }
                widget.onInit();
                Navigator.of(context).pop();
                print("((((7777))))");
              },
              style: TextButton.styleFrom(
                primary: Colors.white, // Set the text color here
                backgroundColor: Colors.deepOrange, // Set the background color here
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                child: Text(
                  isEditing() ? 'Изменить коллекцию' : 'Добавить коллекцию',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          )
        ],
    );
  }

  Widget addImage(){
    print("99999999999999999999");
    if (_imageFile == null){
      print("yyyyyyyyyyyyyyyyyyy  111");
      return Container(
          width: 400, // Specify the desired width of the image
          height: 300,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              isEditing() ?
              Container(
                  width: 400, // Specify the desired width of the image
                  height: 300,
                  child: Image.network(widget.imageUrl!, fit: BoxFit.cover)
              )
              : Container(
                  width: 400, // Specify the desired width of the image
                  height: 300,
                  color: Colors.white54,
              ),
              TextButton(
                onPressed: () => getImageFromGallery(),
                child: Text("Изменить картинку", style: TextStyle(fontSize: 20, color: Colors.white),),
                style: TextButton.styleFrom(
                  primary: Colors.black, // Set the text color here
                  backgroundColor: Colors.deepOrange, // Set the background color here
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ],
          )

      );
    } else {
      print("yyyyyyyyyyyyyyyyyyy  222");
      return Container(
          width: 400, // Specify the desired width of the image
          height: 300,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                  width: 400, // Specify the desired width of the image
                  height: 300,
                  child: Image.file(_imageFile!, fit: BoxFit.cover,)
              ),
              TextButton(
                onPressed: () => getImageFromGallery(),
                child: Text("Изменить картинку", style: TextStyle(fontSize: 20, color: Colors.white),),
                style: TextButton.styleFrom(
                  primary: Colors.black, // Set the text color here
                  backgroundColor: Colors.deepOrange, // Set the background color here
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ],
          )

      );
    }
  }

  //
  // Widget addImage(){
  //   if (_imageFile != null){
  //     return Container(
  //         width: 400, // Specify the desired width of the image
  //         height: 300,
  //         child: Image.file(_imageFile!, fit: BoxFit.cover,)
  //     );
  //   } else {
  //     return Center(
  //       child: TextButton(
  //         onPressed: () => getImageFromGallery(),
  //         child: Text("Добавьте картинку", style: TextStyle(fontSize: 20),),
  //         style: TextButton.styleFrom(
  //           primary: Colors.black, // Set the text color here
  //           backgroundColor: Colors.white, // Set the background color here
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(30.0),
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  // }

  Future<void> getImageFromGallery() async {
    imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    pickedFile = XFile(imageFile.path);
    dropped_image = await convertToDroppedFile(pickedFile);

    // isImage = true;
    print("(((((((((imageFile)))))))))");
    print(imageFile);

    if (imageFile != null) {
      setState(() {
        // AddCollection(context);
        setState(() {
          _imageFile = File(imageFile.path);
        });

        // build(context);
        print("8888888888888888888");
        print(_imageFile);
      });

    }
  }

  Future<DroppedFile?> convertToDroppedFile(XFile? imageFile) async {
    if (imageFile == null) return null;

    String name = imageFile.name;
    String mime = 'image/jpeg'; // Замените это на фактический MIME-тип изображения (image/jpeg, image/png и т.д.)

    Uint8List bytes = await imageFile.readAsBytes();
    int size = bytes.lengthInBytes;

    return DroppedFile(
      name: name,
      mime: mime,
      bytes: bytes,
      size: size,
    );
  }
}
