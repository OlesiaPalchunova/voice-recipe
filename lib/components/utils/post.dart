import 'package:flutter/material.dart';

class Post extends StatelessWidget {
  final String name;
  final String time;
  final String count_portions;
  final String image;
  final String catalogue;

  Post({required this.name, required this.time, required this.count_portions, required this.image, required this.catalogue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
      child: Container(
        width: 160,
        height: 210,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Icon(Icons.timelapse),
                    Text(time),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Row(
                    children: [
                      Icon(Icons.dining_sharp),
                      Text(count_portions),
                    ],
                  ),
                )
              ],
            ),
            Container(
              height: 130,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            )
            //Image.asset(image)
          ],
        ),

      ),
    );
  }
}
