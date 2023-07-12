import 'package:flutter/material.dart';
import 'package:voice_recipe/components/utils/bubble_sroties.dart';
import 'package:voice_recipe/components/utils/user_posts.dart';



class UserHome extends StatelessWidget {
  final List people = [
    'ttn',
    'dbt',
    'sdge',
    'tgtn',
    'ergk',
    'q3e',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Text(
                'Instagram',
                style: TextStyle(color: Colors.black),
            ),
            Icon(Icons.share),
          ],
        ),
      ),
      body: Column(
        children: [
            Container(
              height: 130,
              child:
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                    itemCount: people.length,
                    itemBuilder: (context, index) {
                      // return BubbleStories(text: people[index], image: 'assets/images/sugar',);
                      return Container();
                    }
                )
            ),
          Expanded(
              child: ListView.builder(
                  itemCount: people.length,
                  itemBuilder: (context, index){
                    return UserPosts(
                        name: people[index],
                    );
                  }),
          ),
        ],
      )
    );
  }
}

