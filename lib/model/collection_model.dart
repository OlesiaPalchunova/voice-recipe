import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:routemaster/routemaster.dart';
import 'package:voice_recipe/model/collection.dart';
import 'package:voice_recipe/model/recipes_info.dart';

import '../pages/profile_collection/specific_collections_page.dart';
import '../services/db/collection_db.dart';
import 'dialog/update _collection.dart';
import 'dropped_file.dart';

class CollectionModel extends StatefulWidget {
  // String name;
  // int count;
  // final int id;
  // String imageUrl;
  Collection collection;
  final void Function(int id) onDelete;
  final void Function(int id, DroppedFile? dropped_image, String imageUrl, String name, Collection collection) onUpdate;
  final void Function() onInit;

  CollectionModel({required this.collection, required this.onDelete, required this.onUpdate, required this.onInit});


  @override
  State<CollectionModel> createState() => _CollectionModelState();

}

class _CollectionModelState extends State<CollectionModel> {
  String get name => widget.collection.name;
  int get count => widget.collection.count;
  int get id => widget.collection.id;
  String get imageUrl => widget.collection.imageUrl;
  Collection get collection => widget.collection;

  TextEditingController _collectionNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _collectionNameController.text = name;
    // collection = Collection(id: widget.id, name: widget.name, imageUrl: widget.imageUrl, count: widget.count);
  }

  var imageFile;
  var pickedFile;
  static DroppedFile? dropped_image;
  File? _imageFile;

  Future openCollection() async {
    // List<Recipe> collection = await CollectionDB.getCollection(widget.id).then((result) {
    //   Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => SpecificCollectionPage(recipes: collection),
    //   ));
    // });;

    // Map<int, Recipe>? collection = await CollectionDB.getCollection(id);
    if (collection != null) {
      // Navigator.of(context).push(MaterialPageRoute(
      //   builder: (context) => SpecificCollectionPage(collectionId: id,),
      // ));
      String currentRoute = Routemaster.of(context).currentRoute.fullPath;
      String route = currentRoute + '${SpecificCollectionPage.route}$id';
      Routemaster.of(context).push(route);
      // print(HomePage.route);
      // if (currentRoute != HomePage.route) {
      //   route = '$currentRoute/${recipe.id}';
      //   print("route: $route");
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("((((((((((7777))))))))))");
        openCollection();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
        child: Container(
          width: 350,
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
                        image: NetworkImage(imageUrl), // Укажите URL изображения здесь
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Column(
                    children: [
                      Text(name, style: TextStyle(fontSize: 20),),
                      Text("Число рецептов: ${count}"),
                      SizedBox(height: 5,),
                      OutlinedButton(
                        onPressed: () {
                          EditCollection(context);
                        },
                        child: Text(
                          'Редактировать',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0.0, -4.0),
                        child: OutlinedButton(
                          // onPressed: () {
                          //   // CollectionDB.deleteCollection(id);
                          //   onDelete()
                          // },
                          onPressed: () => widget.onDelete(id),
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

  void Update() {
    widget.onUpdate;
  }

  void EditCollection(BuildContext context){
    showDialog(
        context: context,
        builder: (context) => UpdateCollection(text: name, id: id, imageUrl: imageUrl, onInit: widget.onInit)
    );
  }

}