import 'package:cookie_jar/cookie_jar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_fields.dart';
import '../../model/collections_info.dart';
import '../db/user_db.dart';
import 'Token.dart';

class Authorization {

  final Token token = Token();

  static Future<int> loginUser(String nickname, String password) async{

    var reqBody = {
      "login":nickname,
      "password":password,
    };

    var response = await http.post(Uri.parse('${apiUrl}login/mobile'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody)
    );
    print("666666666666666666");
    print(response.body);



    print("666666666666666666");
    print(response.statusCode);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var accessToken = jsonResponse["accessToken"];
      var refreshToken = jsonResponse["refreshToken"];
      print(refreshToken);

      // Token.saveAccessToken(accessToken);
      // Token.saveRefreshToken(refreshToken);

      Token.setAccessToken(accessToken);
      Token.setRefreshToken(refreshToken);

      await UserDB.init();
      CollectionsInfo.init();
    } else {
      print("555555555555555555");
    }
    return response.statusCode;
  }

  static Future<int> registerUser(String nickname, String password, String displayName, String email) async{

    var reqBody = {
      "login":nickname,
      "password":password,
      "display_name":displayName,
      "email":email,
    };

    print(nickname);
    print(password);
    print(displayName);
    print(email);

    var response = await http.post(Uri.parse('${apiUrl}registration/mobile'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody)
    );

    print(response.statusCode);
    print(response.body);
    print("8888888");

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var accessToken = jsonResponse["accessToken"];
      var refreshToken = jsonResponse["refreshToken"];

      // Token.saveAccessToken(accessToken);
      // Token.saveRefreshToken(refreshToken);

      Token.setAccessToken(accessToken);
      Token.setRefreshToken(refreshToken);

      UserDB.addUser(nickname, displayName, password);
    } else {
      print("555555555555555555");
    }

    return response.statusCode;
  }

  static Future refreshTokens() async{
    // var oldRefreshToken = Token.getRefreshToken();
    String oldRefreshToken = await Token.getRefreshToken();

    var reqBody = {
      "refreshToken": oldRefreshToken,
    };

    print(oldRefreshToken);

    var response = await http.post(Uri.parse('${apiUrl}auth/refresh/mobile'),
        headers: {
          // 'Authorization': 'Bearer $oldRefreshToken',
          "Content-Type": "application/json"},
        body: jsonEncode(reqBody)
    );
    print("kkkkkkkkjjjjj");
    print(response.statusCode);
    print(response.body);


    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var accessToken = jsonResponse["accessToken"];
      var refreshToken = jsonResponse["refreshToken"];
      //
      // Token.saveAccessToken(accessToken);
      // Token.saveRefreshToken(refreshToken);

      Token.setAccessToken(accessToken);
      Token.setRefreshToken(refreshToken);

    } else {
      print("555555555555555555");
    }

    return response.statusCode;
  }

  static Future refreshAccessToken() async {

    // var oldRefreshToken = Token.getRefreshToken();
    String oldRefreshToken = await Token.getRefreshToken() ?? " ";
    print("7777777777777777777777777777777777777777777");
    print(oldRefreshToken);

    var reqBody = {
      "refreshToken": oldRefreshToken,
    };


    try {
      print("kjkjkkjkjkjkjkj");
      final response = await http.post(
        Uri.parse('${apiUrl}auth/token'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody)
      );
      print("kjkjkkjkjkjkjkj");
      print(response.statusCode);

      if (response.statusCode == 200) {
        print("khkhkhkh");
        Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData);
        String newAccessToken = responseData['accessToken'];
        print("khkhkhkh");
        // Token.saveAccessToken(newAccessToken);

        print(newAccessToken);

        Token.setAccessToken(newAccessToken);

        print('Токены успешно обновлены');
      } else {
        print('Ошибка обновления токенов: ${response.statusCode}');
      }
      return response.statusCode;
    } catch (e) {
      // Обработайте ошибки, связанные с выполнением запроса
      print('Ошибка: $e');
      return 1;
    }
  }

}