import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voice_recipe/model/collections_info.dart';
import 'package:voice_recipe/model/dialog/update%20_collection.dart';
import 'package:voice_recipe/services/db/collection_db.dart';

import '../../components/appbars/title_logo_panel.dart';
import '../../components/utils/animated_loading.dart';
import '../../model/collection.dart';
import '../../model/collection_model.dart';
import '../../services/BannerAdPage.dart';
import '../../services/db/collection_db.dart';
import '../../model/dropped_file.dart';
import '../../services/db/user_db.dart';
import '../../services/service_io.dart';

class CollectionPage extends StatefulWidget {
  CollectionPage({super.key});


  @override
  State<CollectionPage> createState() => _CollectionPageState();

}

class _CollectionPageState extends State<CollectionPage> {
  // final List<CollectionModel> collections = [
  //   CollectionModel(name: "Сладкое", count: 3, imageUrl: "https://www.obedsmile.ru/images/stories/article/kak-pravilno-est-sladkoe.jpg"),
  //   CollectionModel(name: "Ужин", count: 3, imageUrl: "https://e2.edimdoma.ru/data/posts/0002/4280/24280-ed4_wide.jpg?1637656619"),
  //   CollectionModel(name: "Закуски", count: 3, imageUrl: "https://img1.russianfood.com/dycontent/images_upl/418/big_417048.jpg"),
  //   CollectionModel(name: "Праздничное", count: 3, imageUrl: "https://lingua-airlines.ru/wp-content/uploads/2017/12/christmas.jpg"),
  // ];

  List<CollectionModel> collections = [];

  // bool isImage = false;
  var imageFile;
  var pickedFile;
  static DroppedFile? dropped_image;
  File? _imageFile;
  static Collection collection = Collection(id: 0, name: "null", imageUrl: "null", count: 0);

  int isAddedCollections = 0;

  static List<Collection> collectionsDB = [];

  TextEditingController _collectionNameController = TextEditingController();

  void _onDelete(int id) async {
    await CollectionDB.deleteCollection(id);
    await initCollection();
  }

  void _onUpdate(int id, DroppedFile? dropped_image, String imageUrl, String name, Collection collection) async {
    await CollectionDB.updateCollection(
        id: id,
        imageFile: dropped_image,
        collection: collection,
        name: name,
        imageUrl: imageUrl
    );
    await initCollection();
  }

  void _onCreate(int id, DroppedFile? dropped_image, String imageUrl, String name, Collection collection) async {
    await CollectionDB.updateCollection(
        id: id,
        imageFile: dropped_image,
        collection: collection,
        name: name,
        imageUrl: imageUrl
    );
    await initCollection();
  }

  Future initCollection() async{
    List<Collection> c = [];
    await CollectionDB.getCollections(c, UserDB.uid);
    setState(() {
      print("collections");

      collections.clear();
      CollectionsInfo.restCollections.clear();
      for (var collection in c) {
        if (collection.name != UserDB.uid + "_saved" && collection.name != UserDB.uid + "_liked") {
          collections.add(CollectionModel(collection: collection, onDelete: _onDelete, onUpdate: _onUpdate, onInit: initCollection));
          CollectionsInfo.restCollections.add(collection);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    print("(((collection.id)))");
    for (var collection in CollectionsInfo.restCollections) {
      print(collection.id);
      collections.add(CollectionModel(
          collection: collection,
          onDelete: _onDelete,
          onUpdate: _onUpdate,
          onInit: initCollection));
    }
    print("(((((((((collections)))))))))");
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop();
    return true;
  }

  // void _onClose(BuildContext context) {
  //   ReviewsSlide.commentController.clear();
  //   _listener.shutdown();
  //   Navigator.of(context).pop();
  // }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold (
          appBar: const TitleLogoPanel(title: "Мои коллекции").appBar(),
          // backgroundColor: Config.backgroundEdgeColor,
          backgroundColor: Colors.deepOrange[50],
          bottomNavigationBar: BottomBannerAd(),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Wrap(
                    spacing: 0.0,  // Расстояние между элементами по горизонтали.
                    runSpacing: 0.0,  // Расстояние между строками.
                    children: [
                      for (CollectionModel e in collections) e,
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Container(
                      width: 300,
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
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
                    ),
                  )
                ],
              ),
            ),
          ),
      ),
    );
  }

  void AddCollection(BuildContext context){
    showDialog(
        context: context,
        builder: (context) => UpdateCollection(text: "", id: -1, imageUrl: null, onInit: initCollection)
    );
  }

}
