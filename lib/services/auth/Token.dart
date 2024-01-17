import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../db/user_db.dart';
import 'Cookie.dart';

class Token{
  static final FlutterSecureStorage storage = FlutterSecureStorage();
  static bool is_token = false;

  static void init() async{
    print(await storage.read(key: 'access_token'));
    if (await storage.containsKey(key: 'access_token')) is_token = true;
  }

  static bool isToken(){
    print("999999999");
    print(is_token);
    return is_token;
  }

  static void notToken(){
    print("777777777777777777");
    is_token = false;
  }

  static Future<void> setAccessToken(String newAccessToken) async {
    await storage.write(key: 'access_token', value: newAccessToken);
    is_token = true;
  }

  static void setRefreshToken(String newRefreshToken) async {
    await storage.write(key: 'refresh_token', value: newRefreshToken);
  }

  static Future getAccessToken() async {
    return await storage.read(key: 'access_token');
  }

  static Future getRefreshToken() async {
    return await storage.read(key: 'refresh_token');
  }

  static void deleteAccessToken() async {
    await storage.delete(key: 'access_token');
    is_token = false;
    UserDB.deleteUid();
    UserDB.deleteName();
    UserDB.deletePassword();
  }

  static void deleteRefreshToken() async {
    await storage.delete(key: 'refresh_token');
  }

  static void deleteAll() async {
    await storage.deleteAll();
    is_token = false;
  }

}