import 'package:flutter/material.dart';
import 'package:voice_recipe/model/collections_info.dart';

import '../../services/db/collection_db.dart';
import '../collection_model.dart';

class CollectionChoice extends StatefulWidget {
  final int recipe_id;

  CollectionChoice({required this.recipe_id});

  @override
  _CollectionChoiceState createState() => _CollectionChoiceState();
}

class _CollectionChoiceState extends State<CollectionChoice> {
  List<CollectionModel> collection = CollectionsInfo.restCollections;

  List<bool> _isChecked = List<bool>.generate(1000, (index) => false);


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
          child: Text("Выберите коллекции")
      ),
      content: Container(
        height: 150,
        width: 150,
        child: ListView.builder(
          itemCount: collection.length,
          itemBuilder: (context, index) {
            return CheckboxListTile(
              title: Text(collection[index].name),
              value: _isChecked[index],
              onChanged: (bool? newValue) {
                setState(() {
                  _isChecked[index] = !_isChecked[index];
                });
              },
              activeColor: Colors.deepOrangeAccent,
              checkColor: Colors.white,
              controlAffinity: ListTileControlAffinity.leading,
              tristate: true,
            );
          },
        ),
      ),
      actions: <Widget>[
        Center(
          child: Container(
            width: 100,
            child: ElevatedButton(
              onPressed: () {
                for (int i = 0; i < collection.length; i++) {
                  if (!_isChecked[i]) continue;
                  CollectionDB.connectCollection(recipe_id: widget.recipe_id, collection_id: collection[i].id);
                }
                Navigator.of(context).pop();
              },
              child: Center(
                  child: Text("Выбрать")
              ),
            ),
          ),
        ),
      ],
    );
  }
}


