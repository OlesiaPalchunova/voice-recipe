import 'package:cookie_jar/cookie_jar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_fields.dart';
import 'Token.dart';

class Authorization {

  static void loginUser(String nickname, String password) async{

    var reqBody = {
      "login":nickname,
      "password":password,
    };

    var response = await http.post(Uri.parse('${apiUrl}login/mobile'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody)
    );
    print("666666666666666666");

    var jsonResponse = jsonDecode(response.body);

    print("666666666666666666");
    print(response.statusCode);

    if (response.statusCode == 200) {
      var accessToken = jsonResponse["accessToken"];
      var refreshToken = jsonResponse["refreshToken"];
      print(refreshToken);

      Token.saveAccessToken(accessToken);
      Token.saveRefreshToken(refreshToken);
    } else {
      print("555555555555555555");
    }
  }

  static void registerUser(String nickname, String password, String displayName, String email) async{

    var reqBody = {
      "login":nickname,
      "password":password,
      "display_name":displayName,
      // "email":email,
    };

    var response = await http.post(Uri.parse('${apiUrl}registration/mobile'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody)
    );

    var jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var accessToken = jsonResponse["accessToken"];
      var refreshToken = jsonResponse["refreshToken"];

      Token.saveAccessToken(accessToken);
      Token.saveRefreshToken(refreshToken);
    } else {
      print("555555555555555555");
    }
  }

  static Future<int> refreshTokens() async{

    var reqBody = {};

    var oldRefreshToken = Token.getRefreshToken();
    var cookieJar = CookieJar();

    // var client = http.Client(cookieJar: cookieJar);

    var response = await http.post(Uri.parse('${apiUrl}auth/refresh/mobile'),
        headers: {
          'Authorization': 'Bearer $oldRefreshToken',
          "Content-Type": "application/json"},
        body: '{}',
    );
    print("kkkkkkkkjjjjj");
    print(response.statusCode);
    print(response.body);

    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse.body);
    print(jsonResponse.statusCode);


    if (response.statusCode == 200) {
      var accessToken = jsonResponse["accessToken"];
      var refreshToken = jsonResponse["refreshToken"];

      Token.saveAccessToken(accessToken);
      Token.saveRefreshToken(refreshToken);
    } else {
      print("555555555555555555");
    }

    return response.statusCode;
  }

  // Future<void> refreshToken(String refreshToken) async {
  //   String apiUrl = 'https://example.com/api/refresh_token'; // Замените на ваш URL API
  //
  //   try {
  //     final response = await http.post(
  //       Uri.parse('${apiUrl}auth/refresh/mobile'),
  //       // headers: {
  //       //   'set-cookie': 'path=/${apiUrl}',
  //       // },
  //       // headers: 'Cookie': '$cookieName=$cookieValue; HttpOnly',
  //       body: {'refreshToken': refreshToken},
  //     );
  //
  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> responseData = json.decode(response.body);
  //       String newAccessToken = responseData['accessToken'];
  //       String newRefreshToken = responseData['refreshToken'];
  //
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       prefs.setString('accessToken', newAccessToken);
  //       prefs.setString('refreshToken', newRefreshToken);
  //
  //     } else {
  //       // Обработайте ошибку
  //       print('Ошибка обновления токенов: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     // Обработайте ошибки, связанные с выполнением запроса
  //     print('Ошибка: $e');
  //   }
  // }

  Future<void> refreshToken(String refreshToken) async {
    String apiUrl = 'https://example.com/api/refresh_token'; // Замените на ваш URL API

    try {
      final response = await http.post(
        Uri.parse('${apiUrl}auth/token'),
        // headers: {
        //   'set-cookie': 'path=/${apiUrl}',
        // },
        // headers: 'Cookie': '$cookieName=$cookieValue; HttpOnly',
        body: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        // Обработайте успешный ответ от сервера
        Map<String, dynamic> responseData = json.decode(response.body);
        String newAccessToken = responseData['accessToken'];
        String newRefreshToken = responseData['refreshToken'];

        // Сохраните новые токены локально на устройстве
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('accessToken', newAccessToken);
        prefs.setString('refreshToken', newRefreshToken);

        print('Токены успешно обновлены');
      } else {
        // Обработайте ошибку
        print('Ошибка обновления токенов: ${response.statusCode}');
      }
    } catch (e) {
      // Обработайте ошибки, связанные с выполнением запроса
      print('Ошибка: $e');
    }
  }
}