import 'package:flutter/material.dart';

import '../../components/appbars/user_page_panel.dart';
import '../../components/utils/post.dart';
import '../../config/config.dart';

class CataloguePage  extends StatefulWidget{

  static var route = "/catalogue1/";

  // const CataloguePage({ Key? key}) : super(key: key);

  final String name;
  final List<Post> posts;

  const CataloguePage({required this.name, required this.posts});


  @override
  _CataloguePageState createState() => _CataloguePageState(name: name, posts: posts);
}

// Future<List<Post>> Create_new(List<Post> posts, String name) async{
//   List<Post> new_posts = [];
//   int i;
//   for (var post in posts) {
//     post.catalogue == name ? new_posts.add(post) : i = 2;
//     }
//   }
// }



class _CataloguePageState extends State<CataloguePage> {
  _CataloguePageState({required this.name, required this.posts});

  final String name;
  final List<Post> posts;

  List<Post> new_posts = [];

  // final List<Post> new_posts =[];
  int i = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var post in posts) {
      if(post.catalogue == name) new_posts.add(post);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Config.defaultAppBar,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              width: 500.0,
              height: 50.0,
              color: Colors.deepOrange[100],
              // margin: new EdgeInsets.symmetric(horizontal: 120.0),
              child: Center(
                child: Text(
                    name,
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
              ),
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // return posts[index].catalogue == name ? posts[index] : posts[index+1];
                    return new_posts[index];
              },
              childCount: new_posts.length,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 80.0),
          )
        ],
      ),
    );
  }
}
