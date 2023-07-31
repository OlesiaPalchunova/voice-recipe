import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/appbars/user_page_panel.dart';
import '../../components/utils/account_info.dart';
import '../../components/utils/bubble_sroties.dart';
import '../../components/utils/post.dart';
import '../../model/profile.dart';

import 'package:url_launcher/url_launcher.dart';

class UserAccount extends StatefulWidget {

  static var route = "/account/";
  final Profile profile;


  const UserAccount({super.key, required this.profile});

  @override
  State<UserAccount> createState() => _UserAccount();
}


class _UserAccount extends State<UserAccount> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("ppppppppppp");
    print(widget.profile.uid);
  }

  final List<Post> posts = [
    Post(name: 'Пельмени', time: '15 минут', count_portions: '2', image: 'assets/images/dishes/dish1.jpg', catalogue: 'простое',),
    Post(name: 'Сырные шарики', time: '20 минут', count_portions: '2', image: 'assets/images/dishes/dish2.jpg', catalogue: 'закуска',),
    Post(name: 'Яблочный штрудель', time: '40 минут', count_portions: '3', image: 'assets/images/dishes/dish7.jpg', catalogue: 'сладкое',),
    Post(name: 'Рулеты с фаршем', time: '30 минут',  count_portions: '4', image: 'assets/images/dishes/dish3.jpg', catalogue: 'на ужин',),
    Post(name: 'Борщ', time: '60 минут', count_portions: '4', image: 'assets/images/dishes/dish4.jpg', catalogue: 'на обед',),
    Post(name: 'Кексики', time: '60 минут', count_portions: '3', image: 'assets/images/dishes/dish5.jpg', catalogue: 'сладкое',),
    Post(name: 'Пицца', time: '30 минут', count_portions: '4', image: 'assets/images/dishes/dish6.jpg', catalogue: 'простое',),
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

  void _launchURL(String url) async {
    // const url = 'https://stackoverflow.com/questions/44909653/visual-studio-code-target-of-uri-doesnt-exist-packageflutter-material-dart'; // Замените на вашу ссылку
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.deepOrange[50],
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
                                  padding: EdgeInsets.only(left: 30.0),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child:  Text("@${widget.profile.uid}"),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 30.0, bottom: 10.0),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(widget.profile.display_name,
                                      style: TextStyle(fontSize: 25.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Container(
                      width: 350,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 15.0, left: 5.0),
                              child: Icon(
                                Icons.fastfood_outlined,
                              ),
                            ),
                            Text('Количество рецептов: ',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            Text("6",
                              // Text('Количество рецептов: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Радиус, делающий углы карточки круглыми
                      ),
                      child: Container(
                        width: 350,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Описание",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  widget.profile.info ?? "",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Радиус, делающий углы карточки круглыми
                      ),
                      child: Container(
                        width: 350,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 10,),
                            Text(
                              "Перейти по ссылке на соц. сети",
                              style: TextStyle(
                                  fontSize: 18
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 10.0),
                              child: Row(
                                children: [
                                  RawMaterialButton(
                                    shape: CircleBorder(), // Установка формы круга
                                    constraints: BoxConstraints.tightFor(width: 80.0, height: 80.0),
                                    onPressed:(){
                                      _launchURL(widget.profile.tg_link ?? "");
                                    },
                                    child: Image.asset(
                                      "assets/images/icons/telegram.png",
                                      height: 70,
                                      width: 70,
                                    ),
                                  ),
                                  SizedBox(width: 20.0,),
                                  RawMaterialButton(
                                    // shape: CircleBorder(), // Установка формы круга
                                    constraints: BoxConstraints.tightFor(width: 80.0, height: 80.0),
                                    onPressed:(){
                                      _launchURL(widget.profile.vk_link ?? "");
                                    },
                                    child: Image.asset(
                                      "assets/images/icons/vk.png",
                                      height: 70,
                                      width: 70,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    // Container(
                    //   height: 30,
                    //   width: 400,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.only(
                    //       topRight:  Radius.circular(20),
                    //       topLeft:  Radius.circular(20),
                    //     ),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         offset: Offset(0, 3),
                    //         spreadRadius: 2,
                    //         blurRadius: 3,
                    //       ),
                    //     ],
                    //     color: Colors.deepOrange[100],
                    //   ),
                    //   child: Center(child: Text('Коллекции')),
                    // ),
                    Card(
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Container(
                        height: 150,
                        width: 350,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              for (BubbleStories e in list) e,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Container(
                    //   height: 10,
                    //   width: 400,
                    //   decoration: BoxDecoration(
                    //     boxShadow: [
                    //       BoxShadow(
                    //         offset: Offset(0, 3),
                    //         spreadRadius: 2,
                    //         blurRadius: 5,
                    //       ),
                    //     ],
                    //     color: Colors.deepOrange[100],
                    //   ),
                    // ),
                    SizedBox(height: 15,),
                  ],
                )
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  mainAxisSpacing: 0.0,
                  crossAxisSpacing: 0.0),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: posts[index],
                  );
                },
                childCount: posts.length,
              ),
            ),
            // SliverToBoxAdapter(
            //   child: SizedBox(height: 10,),
            // )
          ],
        ),
      ),
    );
  }
}