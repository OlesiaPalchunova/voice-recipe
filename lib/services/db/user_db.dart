import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_recipe/services/db/profile_db.dart';

class UserDB{
  static String uid = "root";
  static String name = "User";
  static String? image = "null";
  static String? info = "info";
  static String? tg = "tg";
  static String? vk = "vk";
  static String? password = "Password";

  static final FlutterSecureStorage storage = FlutterSecureStorage();

  static Future init() async{
    var profile = await ProfileDB().getProfile();

    uid = profile.uid;
    name = profile.display_name;
    image = profile.image;
    info = profile.info;
    tg = profile.tg_link;
    vk = profile.vk_link;

    print("vkvkvkvkvkvkkvk");
    print(vk);
    password = await storage.read(key: 'password');
    // uid = await storage.read(key: 'uid');
    // name = await storage.read(key: 'name');
    // password = await storage.read(key: 'password');
  }

  static int addUser(String login, String display_name, String user_password) {
    print("ooooooooooooo");
    storage.write(key: 'uid', value: login);
    storage.write(key: 'name', value: display_name);
    storage.write(key: 'password', value: user_password);
    init();
    return 0;
  }

  static Future getUserUid() {
    return storage.read(key: 'uid');
  }

  static Future getName() {
    return storage.read(key: 'name');
  }

  static Future getPassword() {
    return storage.read(key: 'password');
  }

  static void deleteUid() async {
    await storage.delete(key: 'uid');
    uid = "";
  }

  static void deleteName() async {
    await storage.delete(key: 'name');
    name = "";
  }

  static void deletePassword() async {
    await storage.delete(key: 'password');
    password = "";
  }

  static void deleteAll() async {
    await storage.deleteAll();
  }

}