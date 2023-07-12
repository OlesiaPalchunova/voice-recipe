import 'package:flutter/material.dart';
import 'package:voice_recipe/components/utils/bubble_sroties.dart';

import 'package:voice_recipe/components/utils/post.dart';

import '../../components/appbars/title_logo_panel.dart';
import '../../components/appbars/user_page_panel.dart';
import '../../components/utils/account_info.dart';

class UserAccount extends StatefulWidget {

  @override
  State<UserAccount> createState() => _UserAccount();
}


class _UserAccount extends State<UserAccount> {
  final List<Post> posts = [
    Post(name: 'Пельмени', time: '15 минут', count_portions: '2', image: 'assets/images/dishes/dish1.jpg', catalogue: 'простое',),
    Post(name: 'Сырные шарики', time: '20 минут', count_portions: '2', image: 'assets/images/dishes/dish2.jpg', catalogue: 'закуска',),
    Post(name: 'Рулеты с фаршем', time: '30 минут',  count_portions: '4', image: 'assets/images/dishes/dish3.jpg', catalogue: 'на ужин',),
    Post(name: 'Борщ', time: '60 минут', count_portions: '4', image: 'assets/images/dishes/dish4.jpg', catalogue: 'на обед',),
    Post(name: 'Кексики', time: '60 минут', count_portions: '3', image: 'assets/images/dishes/dish5.jpg', catalogue: 'сладкое',),
    Post(name: 'Пицца', time: '30 минут', count_portions: '4', image: 'assets/images/dishes/dish6.jpg', catalogue: 'простое',),
    Post(name: 'Пицца', time: '30 минут', count_portions: '4', image: 'assets/images/dishes/dish6.jpg', catalogue: 'закуска',),
  ];

  late final List<BubbleStories> list = [
    BubbleStories(text: 'сладкое', image: 'assets/images/catalogues/sugar.jpg', posts: posts,),
    BubbleStories(text: 'простое', image: 'assets/images/catalogues/sandwich.jpg', posts: posts,),
    BubbleStories(text: 'на обед', image: 'assets/images/catalogues/dinner.jpg', posts: posts,),
    BubbleStories(text: 'на ужин', image: 'assets/images/catalogues/holiday.jpg', posts: posts,),
    BubbleStories(text: 'закуска', image: 'assets/images/catalogues/sugar.jpg', posts: posts,),
    BubbleStories(text: 'праздничное', image: 'assets/images/catalogues/sugar.jpg', posts: posts,),
    BubbleStories(text: 'праздничное', image: 'assets/images/catalogues/sugar.jpg', posts: posts,),
  ];

    static Account account = Account(nickname: '@ivan_zolo', name: 'Иван Сидоров', count_recipes: '645', count_followers: '1246');
    String nickname = 'fgf';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: const TitleUserPanel(title: "Страница пользователя").appBar(),
        body: CustomScrollView(            //scrollDirection: Axis.vertical,
          slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage("assets/images/user.jpg")
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 28.0),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child:  Text(account.nickname),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 15.0, bottom: 10.0),
                                  child: Text(account.name,
                                    style: TextStyle(fontSize: 30.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Center(child: Text('Подписаться')),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5),
                                  color:  Colors.deepOrangeAccent,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 15.0),
                            child: Icon(
                              Icons.fastfood_outlined,
                            ),
                          ),
                          Text('Количество рецептов: ',
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          Text(account.count_recipes,
                            // Text('Количество рецептов: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, left: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 15.0),
                            child: Icon(
                              Icons.account_circle_outlined,
                            ),
                          ),
                          Text('Подписчики: ',
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          // Text(account.count_followers.toString(),
                          Text(account.count_followers,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      height: 30,
                      width: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight:  Radius.circular(20),
                          topLeft:  Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 3),
                            spreadRadius: 2,
                            blurRadius: 3,
                          ),
                        ],
                        color: Colors.deepOrange[100],
                      ),
                      child: Center(child: Text('Коллекции')),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        height: 130,
                        color: Colors.grey[200],
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (BubbleStories e in list) e,
                          ],
                          //}
                        ),
                      ),
                    ),
                    Container(
                      height: 10,
                      width: 400,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 3),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                        color: Colors.deepOrange[100],
                      ),
                    ),
                    SizedBox(height: 15,),
                    ],
                  )
                ),
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return posts[index];
                    },
                    childCount: posts.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 15,),
                )
              ],
            ),
          ),
    );
  }
}