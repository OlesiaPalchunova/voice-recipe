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
      padding: const EdgeInsets.only(left: 15.0, top: 10.0),
      child: Container(
        width: 170,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
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
