import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voice_recipe/model/collection.dart';
import 'package:voice_recipe/model/recipes_info.dart';

import '../pages/profile_collection/specific_collections_page.dart';
import '../services/db/collection_db.dart';
import 'dropped_file.dart';

class CollectionModel extends StatefulWidget {
  String name;
  int count;
  final int id;
  String imageUrl;

  CollectionModel({required this.name, required this.count, required this.imageUrl, required this.id});


  @override
  State<CollectionModel> createState() => _CollectionModelState();

}

class _CollectionModelState extends State<CollectionModel> {


  TextEditingController _collectionNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _collectionNameController.text = widget.name;
  }

  var imageFile;
  var pickedFile;
  static DroppedFile? dropped_image;
  File? _imageFile;
  static Collection collection = Collection(id: 0, name: "null", imageUrl: "null", number: 0);

  Future openCollection() async {
    // List<Recipe> collection = await CollectionDB.getCollection(widget.id).then((result) {
    //   Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => SpecificCollectionPage(recipes: collection),
    //   ));
    // });;

    Map<int, Recipe>? collection = await CollectionDB.getCollection(widget.id);
    if (collection != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SpecificCollectionPage(recipes: collection, collectionId: widget.id,),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // await CollectionDB.getCollections(c, 'les').then((result){}
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => SpecificCollectionPage(),
        // ));
        print("((((((((((7777))))))))))");
        openCollection();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Container(
          width: 300,
          height: 180,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white
          ),
          child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.deepOrange[100]
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image(
                        image: NetworkImage(widget.imageUrl), // Укажите URL изображения здесь
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Text(widget.name, style: TextStyle(fontSize: 20),),
                      Text("Число рецептов: ${widget.count}"),
                      SizedBox(height: 5,),
                      OutlinedButton(
                        onPressed: () {
                          AddCollection(context);
                        },
                        child: Text(
                          'Редактировать',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0.0, -4.0),
                        child: OutlinedButton(
                          onPressed: () {
                            CollectionDB.deleteCollection(widget.id);
                          },
                          child: Text(
                            '      Удалить       ',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ]
          ),
        ),
      ),
    );
  }

  void AddCollection(BuildContext context){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
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
                    child: TextFormField(
                      controller: _collectionNameController,
                      decoration: InputDecoration(
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
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  print("ppppppppppppp");
                  print(_collectionNameController.text);
                  CollectionDB.updateCollection(
                      id: widget.id,
                      imageFile: dropped_image,
                      collection: collection,
                      name: _collectionNameController.text
                  );
                  setState(() {
                    widget.name = _collectionNameController.text;
                    // widget.imageUrl = collection.imageUrl;
                  });
                  Navigator.of(context).pop();
                  // initCollection();
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
                  child: Text('Изменить коллекцию', style: TextStyle(fontSize: 20),),
                ),
              ),
            )
          ],
        )
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
                Container(
                    width: 400, // Specify the desired width of the image
                    height: 300,
                    child: Image.network(widget.imageUrl, fit: BoxFit.cover)
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

  Future<void> getImageFromGallery() async {
    imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    pickedFile = XFile(imageFile.path);
    dropped_image = await convertToDroppedFile(pickedFile);

    // isImage = true;
    print("(((((((((imageFile)))))))))");
    print(imageFile);

    if (imageFile != null) {
      setState(() {
        _imageFile = File(imageFile.path);
        AddCollection(context);

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
