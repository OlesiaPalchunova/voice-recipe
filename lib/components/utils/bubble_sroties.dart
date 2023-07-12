import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:voice_recipe/components/utils/post.dart';
import 'package:voice_recipe/pages/profile_collection/catalogue_page.dart';

import '../../pages/user/user_page.dart';

class  BubbleStories extends StatelessWidget {
  final String text;
  final String image;
  final List<Post> posts;

  BubbleStories({required this.text, required this.image, required this.posts});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CataloguePage(name: text, posts: posts,)));
        },
        child: Column(
          children: [
            Container(
              height: 20,
              width: 100,
              //color: Colors.brown[800],
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.only(
                    topRight:  Radius.circular(10),
                    topLeft:  Radius.circular(10),
                  ),
                color: Colors.white,
              ),
              child: Center(child: Text(text, style:
                TextStyle(
                  color: Colors.black,
                  overflow: TextOverflow.ellipsis,
                )
                ,)
              ),
            ),
            Container(
                width: 100,
                height: 90,
                decoration: BoxDecoration(
                  // image: DecorationImage(
                  //   image: AssetImage("images/img1.jpg"),
                  //   fit: BoxFit.cover,
                  // ),
                  border: Border.all(color: Colors.black),
                  // borderRadius: BorderRadius.only(
                  //   bottomRight:  Radius.circular(10),
                  //   bottomLeft:  Radius.circular(10),
                  // ),
                  color: Colors.orange[50],
                  // boxShadow: [
                  //   BoxShadow(
                  //     offset: Offset(0, 3),
                  //     spreadRadius: 2,
                  //     blurRadius: 3,
                  //   ),
                  // ],
                ),
                child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                    )
                ),
            // Container(
            //     width: 100,
            //     height: 100,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.all(Radius.circular(10)),
            //       color: Colors.grey[400],
            //     )
            // ),
            // SizedBox(
            //   height: 5,
            // ),
            // Container(
            //     width: 70,
            //     child: Text(
            //       text,
            //       overflow: TextOverflow.ellipsis,
            //       style: TextStyle(
            //         fontSize: 15.0,
            //       ),
            //     )
            // )
          ],
        ),
      ),
    );
  }
}
