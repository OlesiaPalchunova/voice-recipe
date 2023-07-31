import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/appbars/title_logo_panel.dart';
import '../../model/collection_model.dart';
import '../../model/dropped_file.dart';

class CollectionPage extends StatefulWidget {
  CollectionPage({super.key});


  @override
  State<CollectionPage> createState() => _CollectionPageState();

}

class _CollectionPageState extends State<CollectionPage> {
  final List<CollectionModel> collections = [
    CollectionModel(name: "Сладкое", count: 3, imageUrl: "https://www.obedsmile.ru/images/stories/article/kak-pravilno-est-sladkoe.jpg"),
    CollectionModel(name: "Ужин", count: 3, imageUrl: "https://e2.edimdoma.ru/data/posts/0002/4280/24280-ed4_wide.jpg?1637656619"),
    CollectionModel(name: "Закуски", count: 3, imageUrl: "https://img1.russianfood.com/dycontent/images_upl/418/big_417048.jpg"),
    CollectionModel(name: "Праздничное", count: 3, imageUrl: "https://lingua-airlines.ru/wp-content/uploads/2017/12/christmas.jpg"),
  ];

  // bool isImage = false;
  var imageFile;
  var pickedFile;
  static DroppedFile? dropped_image;
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold (
        appBar: const TitleLogoPanel(title: "Мои коллекции").appBar(),
        // backgroundColor: Config.backgroundEdgeColor,
        backgroundColor: Colors.deepOrange[50],
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              for (CollectionModel e in collections) e,
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: TextButton(
                  onPressed: () {
                    AddCollection(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set the background color
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0), // Set the border radius
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60.0),
                    child: Row(
                      children: [
                        Icon(Icons.add, size: 40,),
                        SizedBox(width: 10,),
                        Text(
                          'Добавить',
                          style: TextStyle(fontSize: 25, color: Colors.black), // Set the text color
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
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
          content: Container(
            height: 300,
            child: Column(
              children: [
                SizedBox(
                  height: 70,
                  child: TextField(
                    // controller: first_old_password,
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
                  // _imageFile == null
                  //   ? Center(
                  //     child: TextButton(
                  //       onPressed: () {
                  //         getImageFromGallery();
                  //       },
                  //       child: Text("Добавьте картинку", style: TextStyle(fontSize: 20),),
                  //       style: TextButton.styleFrom(
                  //         primary: Colors.black, // Set the text color here
                  //         backgroundColor: Colors.white, // Set the background color here
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(30.0),
                  //         ),
                  //       ),
                  //     ),
                  //   )
                  //     : Container(child: Image.file(_imageFile!))
                )
              ],
            ),
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                },
                style: TextButton.styleFrom(
                  primary: Colors.white, // Set the text color here
                  backgroundColor: Colors.deepOrange, // Set the background color here
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Text('Добавить коллекцию', style: TextStyle(fontSize: 20),),
                ),
              ),
            )
          ],
        )
    );
  }

  Widget addImage(){
    print("99999999999999999999");
    if (_imageFile != null){
      print("yyyyyyyyyyyyyyyyyyy  111");
      return Container(
          width: 400, // Specify the desired width of the image
          height: 300,
          child: Image.file(_imageFile!, fit: BoxFit.cover,)
      );
    } else {
      print("yyyyyyyyyyyyyyyyyyy  222");
      return Center(
        child: TextButton(
          onPressed: () => getImageFromGallery(),
          child: Text("Добавьте картинку", style: TextStyle(fontSize: 20),),
          style: TextButton.styleFrom(
            primary: Colors.black, // Set the text color here
            backgroundColor: Colors.white, // Set the background color here
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
      );
    }
  }

  Future<void> getImageFromGallery() async {
    imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    // pickedFile = XFile(imageFile.path);
    // dropped_image = await convertToDroppedFile(pickedFile);
    //
    // isImage = true;

    if (imageFile != null) {
      setState(() {
        _imageFile = File(imageFile.path);
        build(context);
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
