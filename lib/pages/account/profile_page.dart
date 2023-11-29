import 'dart:typed_data';

import 'package:voice_recipe/model/collections_info.dart';

import '../../config/config.dart';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:share_plus/share_plus.dart';
import 'package:voice_recipe/components/appbars/title_logo_panel.dart';
import 'package:voice_recipe/components/recipe_collection_views/collection_header_card.dart';
import 'dart:io';

import 'package:voice_recipe/config/config.dart';
import 'package:voice_recipe/model/sets_info.dart';
import 'package:voice_recipe/model/users_info.dart';
import 'package:voice_recipe/pages/collections/future_collection_page.dart';
import 'package:voice_recipe/services/auth/Token.dart';
import 'package:voice_recipe/services/service_io.dart';

import '../../components/buttons/classic_button.dart';
import '../../components/constructor_views/password_label.dart';
import '../../components/text_form_field_widget.dart';
import '../../model/dialog/change_password.dart';
import '../../model/dropped_file.dart';
import '../../model/profile.dart';
import '../../model/recipes_info.dart';
import '../../services/BannerAdPage.dart';
import '../../services/auth/Token.dart';
import '../../services/db/collection_db.dart';
import '../../services/db/profile_db.dart';
import '../../services/db/user_db.dart';

import 'package:image_picker/image_picker.dart';

import '../profile_collection/collection_page.dart';
import '../profile_collection/specific_collections_page.dart';
import '../user/user_page.dart';

class AccountPage extends StatefulWidget {
  AccountPage({super.key, required this.profile});

  Profile profile;

  @override
  State<AccountPage> createState() => _AccountPageState();

}

class _AccountPageState extends State<AccountPage> {

  File? _imageFile;

  TextEditingController _loginController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _tgController = TextEditingController();
  TextEditingController _vkController = TextEditingController();
  String networkImage = "null";

  TextEditingController first_old_password = TextEditingController();
  TextEditingController new_password = TextEditingController();
  TextEditingController second_new_password = TextEditingController();

  bool isEditing = false;


  @override
  void initState() {
    super.initState();
    _loginController.text = UserDB.uid;
    _nameController.text = UserDB.name;
    _descriptionController.text = UserDB.info ?? "";
    _tgController.text = UserDB.tg ?? "";
    _vkController.text = UserDB.vk ?? "";

    networkImage = UserDB.image ?? "null";

    // _loginController.text = widget.profile.uid;
    // _nameController.text = widget.profile.display_name;
    // _descriptionController.text = widget.profile.info ?? "";
    // _tgController.text = widget.profile.tg_link ?? "";
    // _vkController.text = widget.profile.vk_link ?? "";
  }

  Future openMyCollection() async {
    var collection_id = CollectionsInfo.myCollection.id;
    Map<int, Recipe>? collection;
    if (collection_id == 0) collection = {};
    else collection = await CollectionDB.getCollection(collection_id);
    if (collection != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SpecificCollectionPage(recipes: collection, collectionId: collection_id, showCategories: true,),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TitleLogoPanel(title: "Мой профиль").appBar(),
      // backgroundColor: Config.backgroundEdgeColor,
      backgroundColor: Colors.deepOrange[50],
      bottomNavigationBar: BottomBannerAd(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            alignment: Alignment.center,
            // width: Config.loginPageWidth(context),
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // SizedBox(height: 15,),
                Container(
                    padding: const EdgeInsets.all(Config.padding),
                    alignment: Alignment.center,
                    child: buildProfile(context)
                ),
                InkWell(
                  onTap: (){
                    // Routemaster.of(context).push('/created');
                    openMyCollection();
                  },
                  child: Card(
                    // elevation: 3,

                    color: Colors.white.withOpacity(0),
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        Stack(children: [
                          SizedBox(
                            child: AnimatedContainer(
                              duration: Config.animationTime,
                              height: 70,
                              width: Config.loginPageWidth(context) * 0.8,
                              decoration: BoxDecoration(
                                  borderRadius: Config.borderRadius,
                                  color: Colors.white),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 220,
                                  ),
                                  Container(
                                    width: 80,
                                    alignment: Alignment.center,
                                    child: Image(
                                      image: AssetImage("assets/images/decorations/my_recipe.png"),
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 60,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: Config.padding * 2),
                            child: Text("Мои рецепты",
                                style: TextStyle(
                                    fontFamily: Config.fontFamily,
                                    fontSize: 20,
                                    color: Config.iconColor)),
                          ),
                        ]),

                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                InkWell(
                  onTap: (){
                    // Routemaster.of(context).push('/created');
                    // Routemaster.of(context).push(UserPage.route);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CollectionPage(),
                      ),
                    );
                  },
                  child: Card(
                    // elevation: 3,
                    color: Colors.white.withOpacity(0),
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        Stack(children: [
                          SizedBox(
                            child: AnimatedContainer(
                              duration: Config.animationTime,
                              height: 70,
                              width: Config.loginPageWidth(context) * 0.8,
                              decoration: BoxDecoration(
                                  borderRadius: Config.borderRadius,
                                  color: Colors.white),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 220,
                                  ),
                                  Container(
                                    width: 80,
                                    alignment: Alignment.center,
                                    child: Image(
                                      image: AssetImage("assets/images/decorations/my_collection.png"),
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 60,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: Config.padding * 2),
                            child: Text("Мои коллекции",
                                style: TextStyle(
                                    fontFamily: Config.fontFamily,
                                    fontSize: 20,
                                    color: Config.iconColor)),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30,),
              ],
            ),
          ),
        ),
      ),

    );
  }

  Widget _buildWidgetFromData() {
    if (_imageFile != null) {
      print("444444444444444444444444444");
      return Container(
          width: 400, // Specify the desired width of the image
          height: 300,
          child: Image.file(_imageFile!, fit: BoxFit.cover,)
      );
    } else if (networkImage != "null") {
      return Image(
          image: NetworkImage(networkImage), // Укажите URL изображения здесь
          width: 200,
          height: 200,
          fit: BoxFit.cover,
          );
    } else {
      // Return a default Widget if the data type is not recognized
      return Image.asset("assets/images/user.jpg");
    }
  }

  // TextEditingController _textEditingController = TextEditingController();

  Future UpdateData() async{
    await UserDB.init();
  }

  static void _showSnackbar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: Duration(seconds: 2), // Set the duration for which the Snackbar is displayed
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future update() async {
    await ProfileDB().updateProfile(
      userUid: _loginController.text,
      displayName: _nameController.text,
      imageFile: dropped_image,
      info: _descriptionController.text,
      tgLink: _tgController.text,
      vkLink: _vkController.text,
    );
    await UserDB.init();
  }

  Future ChangePasswordDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ChangePassword();
      },
    );
  }

  Widget changeField(String text, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        width: Config.loginPageWidth(context) * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 0.0, top: 7.0),
                child: Text(text, style: TextStyle(color: Colors.grey[500]),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: SizedBox(
                width: Config.loginPageWidth(context) * 0.7,
                // height: 35,
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintText: 'Введите текст...',
                    contentPadding: EdgeInsets.only(top: -5.0),
                  ),
                  minLines: 1,
                  maxLines: null,
                ),
              ),
            ),
            SizedBox(height: 7,)
          ],
        ),
      ),
    );
  }

  Widget infoField(String text, String info) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: Config.loginPageWidth(context) * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 0.0, top: 7.0),
                child: Text(text, style: TextStyle(color: Colors.grey[500]),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: SizedBox(
                width: Config.loginPageWidth(context) * 0.7,
                child: Text(
                    info,
                  softWrap: true,
                )
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfile(BuildContext context) {
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 100.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Config.backgroundColor,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(90),
                            // child: Image.network(defaultProfileUrl),
                            child: _buildWidgetFromData(),
                          ),
                        ),
                      ),
                    ),
                    isEditing ?
                    Positioned(
                      top: 105,
                      left: 195,
                      child:Container(
                        // width: 40,
                        child: ElevatedButton(
                          // onPressed: () => _pickAndLoadFile(context),
                          onPressed: () => _getImageFromGallery(),
                          child: Container(
                              margin: EdgeInsets.only(left: 0),
                              child: Icon(Icons.add_circle, size: 50, color: Colors.deepOrange,)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ),
                        ),
                      ),
                    )
                    : SizedBox()
                  ]
                ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0, top: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Радиус, делающий углы карточки круглыми
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // color: Colors.white,
                      child: IconButton(
                          onPressed: () {
                            Token.deleteAccessToken();
                            Token.deleteRefreshToken();
                            UserDB.deleteAll();
                            Routemaster.of(context).pop();
                          },
                          tooltip: "Выйти из аккаунта",
                          icon: Icon(Icons.logout, color: Config.iconColor)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        isEditing ? Column(
          children: [
            changeField("Логин", _loginController),
            changeField("Имя", _nameController),
            changeField("Описание", _descriptionController),
            changeField("Ссылка на Телеграм", _tgController),
            changeField("Ссылка на ВКонтакте", _vkController),
          ],
        )
        : Column(
          children: [
            infoField("Логин", _loginController.text),
            infoField("Имя", _nameController.text),
            infoField("Описание", _descriptionController.text),
            infoField("Ссылка на Телеграм", _tgController.text),
            infoField("Ссылка на ВКонтакте", _vkController.text),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: (){
              if (isEditing) {
                update();
                _showSnackbar(context, "Изменения сохранены");
              }
              setState(() {
                isEditing = !isEditing;
              });
            },
            child: Text(
              isEditing ? "Сохранить изменения" : "Изменить данные",
              style: TextStyle(
                  fontSize: 20
              ),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange), // Цвет фона кнопки
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)), // Отступы внутри кнопки
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Радиус, делающий края круглыми
                  ),
                ),
                fixedSize: MaterialStateProperty.all<Size>(
                  Size(Config.loginPageWidth(context) * 0.8, 55),
                )
            ),
          ),
        ),

        ElevatedButton.icon(
          onPressed: () async {
            print('Кнопка с текстом и иконкой нажата!');
            await ChangePasswordDialog(context);
          },
          icon: Icon(Icons.key), // Иконка
          label: Text('Изменить пароль'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Радиус, делающий края круглыми
              ),
            ),
            fixedSize: MaterialStateProperty.all<Size>(
              Size(Config.loginPageWidth(context) * 0.8, 40),
            )
          ),// Текст
        ),

        SizedBox(height: 10,),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Радиус, делающий углы карточки круглыми
          ),
          child: Container(
            width: Config.loginPageWidth(context) * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                SizedBox(height: 10,),
                Text(
                  "Перейти по ссылке на соц. сети",
                  style: TextStyle(
                    fontSize: 15
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 10.0),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/icons/telegram.png",
                        height: 70,
                        width: 70,
                      ),
                      SizedBox(width: 20.0,),
                      Image.asset(
                        "assets/images/icons/vk.png",
                        height: 70,
                        width: 70,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  var imageFile;
  var pickedFile;
  int? _imageSizeInBytes;

  static DroppedFile? dropped_image;

  Future<void> _getImageFromGallery() async {
    imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    pickedFile = XFile(imageFile.path);
    dropped_image = await _convertToDroppedFile(pickedFile);

    if (imageFile != null) {
      setState(() {
        _imageFile = File(imageFile.path);
      });
    }
  }

  Future<DroppedFile?> _convertToDroppedFile(XFile? imageFile) async {
    if (imageFile == null) return null;

    String name = imageFile.name;
    String mime = 'image/jpeg'; // Замените это на фактический MIME-тип изображения (image/jpeg, image/png и т.д.)

    Uint8List bytes = await imageFile.readAsBytes();
    int size = bytes.lengthInBytes;

    return DroppedFile(
      name: name,
      mime: mime,
      bytes: bytes,
      size: size,
    );
  }
}

