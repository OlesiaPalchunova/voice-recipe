import 'package:flutter/material.dart';

class CollectionModel extends StatelessWidget {
  final String name;
  final int count;
  final String imageUrl;

  CollectionModel({required this.name, required this.count, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                      image: NetworkImage(imageUrl), // Укажите URL изображения здесь
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
                    Text(name, style: TextStyle(fontSize: 20),),
                    Text("Число рецептов: $count"),
                    SizedBox(height: 5,),
                    OutlinedButton(
                      onPressed: () {
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
    );
  }
}
