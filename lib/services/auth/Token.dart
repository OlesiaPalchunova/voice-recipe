import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../db/user_db.dart';
import 'Cookie.dart';

class Token{
  static final FlutterSecureStorage storage = FlutterSecureStorage();
  static bool is_token = false;

  static void init() async{
    if (await storage.containsKey(key: 'access_token')) is_token = true;
    print("uuuuuuuuuuuuuuu");
    print(is_token);
  }

  static bool isToken(){
    return is_token;
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

  void deleteAll1() async {
    await storage.deleteAll();
  }

}