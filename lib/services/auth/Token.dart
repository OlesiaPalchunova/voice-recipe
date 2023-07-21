import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'Cookie.dart';

class Token{

  static String accesstoken = "000";
  static String refreshtoken = "000";

  final storage = FlutterSecureStorage();

  static void saveAccessToken(String newToken){
    print("ccccccccccccccccccccccccc");
    accesstoken = newToken;
  }

  static String getAccessToken(){
    return accesstoken;
  }

  static void saveRefreshToken(String newToken){
    print("ccccccccccccccccccccccccc");
    refreshtoken = newToken;
  }

  static String getRefreshToken(){
    return refreshtoken;
  }

  static bool isToken(){
    return accesstoken != "000";
  }

  static String getUid(){
    Map<String, dynamic> decodedToken = JwtDecoder.decode(accesstoken);
    print(decodedToken["login"]);
    return decodedToken["login"];
  }

  void Initialize() async {
    await storage.write(key: 'access_token', value: 'your_access_token_here');
    await storage.write(key: 'refresh_token', value: 'your_refresh_token_here');
  }

  Future<String?> getAccessToken1() async {
    String? accessToken = await storage.read(key: 'access_token');
    return accessToken;
  }

  Future<String?> getRefreshToken1() async {
    String? refreshToken = await storage.read(key: 'refresh_token');
    return refreshToken;
  }

  void deleteAccessToken1() async {
    await storage.delete(key: 'access_token');
  }

  void deleteRefreshToken1() async {
    await storage.delete(key: 'refresh_token');
  }

  void deleteAll1() async {
    await storage.deleteAll();
  }

}