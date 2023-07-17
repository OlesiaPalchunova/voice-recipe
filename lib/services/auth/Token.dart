import 'package:shared_preferences/shared_preferences.dart';

import 'Cookie.dart';

class Token{

  static String token = "000";

  static void saveToken(String newToken){
    Cookies.getData();
    Cookies.getDataFromCookie();
    token = newToken;
  }

  static String getToken(){
    return token;
  }

  static bool isToken(){
    return token != "000";
  }

  // static late SharedPreferences prefs;
  //
  // void initSharedPref() async{
  //   prefs = await SharedPreferences.getInstance();
  // }
  //
  // static Future<void> saveAccessToken(String token) async {
  //   initSharedPref();
  //   prefs.setString('accessToken', token);
  // }
  //
  // static Future<String?> getAccessToken() async {
  //   return prefs.getString('accessToken');
  // }
}