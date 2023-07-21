import 'package:http/http.dart' as http;
import 'package:cookie_jar/cookie_jar.dart';
// import 'package:dio/dio.dart';
// import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class Cookies{

  // Future<void> getDataFromCookie() async {
  //   final url = Uri.parse('YOUR_API_URL');
  //
  //   // Создаем CookieManager
  //   var cookieManager = http.CookieManager();
  //
  //   // Отправляем GET запрос и сохраняем cookie в cookieManager
  //   final response = await http.get(url, headers: {'User-Agent': 'my_cookie_testing_app'}, cookies: cookieManager.cookieJar);
  //
  //   // Получаем список cookie
  //   final List<http.Cookie> cookies = cookieManager.cookieJar.loadForRequest(url);
  //
  //   // Печатаем значения cookie
  //   for (var cookie in cookies) {
  //     print('Name: ${cookie.name}, Value: ${cookie.value}');
  //   }
  //
  //   // Здесь вы можете делать что-то еще с полученными данными
  //
  //   final cookieManager = WebviewCookieManager();
  //
  //   final gotCookies = await cookieManager.getCookies('https://youtube.com');
  //   for (var item in gotCookies) {
  //     print(item);
  //   }
  // }

//   // Создание экземпляра CookieJar
//   final dio = Dio();
//   final cookieJar = CookieJar();
//   dio.interceptors.add(CookieManager(cookieJar));
//
// // Функция для получения refresh token из кук
//   Future<String?> getRefreshToken() async {
//   List<Cookie> cookies = await cookieJar.loadForRequest(Uri.parse('http://your-api-url.com'));
//   for (Cookie cookie in cookies) {
//   if (cookie.name == 'refreshToken') {
//   return cookie.value;
//   }
//   }
//   return null;
//   }
//
//
//   static Future<void> getDataFromCookie() async {
//     final url = Uri.parse("https://server.talkychef.ru/");
//     // final cookieJar = CookieJar();
//     //
//     // List<Cookie> results = await cookieJar.loadForRequest(url);
//     // print("ttttttttttttttt");
//     // print(results);
//
//
//     final cookieJar = CookieJar();
//     List<Cookie> cookies = [Cookie('name', 'wendux'), Cookie('location', 'china')];
//     // Saving cookies.
//     await cookieJar.saveFromResponse(Uri.parse('https://pub.dev/'), cookies);
//     // Obtain cookies.
//     List<Cookie> results = await cookieJar.loadForRequest(Uri.parse('https://pub.dev/paths'));
//     print(results);
//     // Создаем CookieJar
//
//   }

  // static Future<http.Response> getData() async {
  //   var cookies = [
  //     'refreshToken',
  //   ];
  //
  //   var headers = {
  //     'Cookie': cookies.join('; '),
  //   };
  //
  //   var response = await http.get((Uri.parse("https://server.talkychef.ru/")), headers: headers);
  //
  //
  //   print("kkkkkkkkkkkk");
  //   print(response.statusCode);
  //   return response;
  // }
}
