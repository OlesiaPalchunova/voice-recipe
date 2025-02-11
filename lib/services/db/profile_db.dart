import 'dart:convert';

import 'package:voice_recipe/api/recipes_sender.dart';
import 'package:voice_recipe/model/dropped_file.dart';
import 'package:voice_recipe/model/users_info.dart';
import 'package:voice_recipe/services/db/user_db.dart';

import '../../api/api_fields.dart';
import '../../model/profile.dart';
import 'package:http/http.dart' as http;

import '../auth/Token.dart';
import '../auth/authorization.dart';

class ProfileDB{

  Future tryUpdateProfile({required String userUid, required String displayName, required DroppedFile? imageFile,
    required String info, required String tgLink, required String vkLink}) async {
    String? markJson = await changedProfileToJson(userUid, displayName, imageFile, info, tgLink, vkLink);
    if (markJson == null) {
      return -1;
    }
    var accessToken = await Token.getAccessToken();
    var response = await http.put(Uri.parse("${apiUrl}profile"),
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: markJson);
    print("updateeee");
    print(response.statusCode);
    print(response.body);
    return response.statusCode;
  }

  Future updateProfile({
    required String userUid, required String displayName, required DroppedFile? imageFile,
    required String info, required String tgLink, required String vkLink}) async {
    var status = await tryUpdateProfile(userUid: userUid, displayName: displayName, imageFile: imageFile,
                                        info: info, tgLink: tgLink, vkLink: vkLink);
    print("vvvvvvvvvvv");
    print("status: $status");
    if (status == 200) return status;

    if (status == 401) {
      int status_access = await Authorization.refreshAccessToken();
      print(status_access);

      if (status_access == 200) {
        return await tryUpdateProfile(userUid: userUid, displayName: displayName, imageFile: imageFile,
                                        info: info, tgLink: tgLink, vkLink: vkLink);
      }
      if (status_access == 401) {
        print("blablabla");
        int status_refresh = await Authorization.refreshTokens();
        if (status_refresh == 200) {
          return await tryUpdateProfile(userUid: userUid, displayName: displayName, imageFile: imageFile,
                                        info: info, tgLink: tgLink, vkLink: vkLink);
        }
      }
    }
    return status;
  }

  Future<String?> changedProfileToJson(String userUid, String displayName, DroppedFile? imageFile, String info, String tgLink, String vkLink) async {

    var imageId = null;
    if (imageFile != null) imageId = await RecipesSender().sendImageRaw(imageFile);
    print("tttttttttt");
    print(imageId);

    Map<String, dynamic> commentDto;
    commentDto = {
      "uid": userUid,
      "display_name": displayName,
      "media_id": imageId,
      "info": info,
      "tg_link": tgLink,
      "vk_link": vkLink,
    };
    print("8888888888888888888");
    print(commentDto);
    var commentJson = jsonEncode(commentDto);
    return commentJson;
  }

  static Future tryUpdatePassword({required String login, required String password}) async {

    String? passwordJson = await changedPasswordToJson(login, password);

    var accessToken = await Token.getAccessToken();
    var response = await http.put(Uri.parse("${apiUrl}profile/password/mobile"),
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: passwordJson);
    print("update password");
    print(response.statusCode);
    print(response.body);
    return response.statusCode;
  }

  static Future updatePassword({
    required String login, required String password}) async {
    var status = await tryUpdatePassword(login: login, password: password);
    print("vvvvvvvvvvv");
    print("status: $status");
    if (status == 200) return status;

    if (status == 401) {
      int status_access = await Authorization.refreshAccessToken();
      print(status_access);

      if (status_access == 200) return await tryUpdatePassword(login: login, password: password);
      if (status_access == 401) {
        print("(((((88667)))))");
        Token.deleteAccessToken();
        Token.deleteRefreshToken();
        UserDB.deleteAll();
        Token.deleteAll();
        // print("blablabla");
        // int status_refresh = await Authorization.refreshTokens();
        // if (status_refresh == 200) return await tryUpdatePassword(login: login, password: password);
      }
    }
    print(";;;;;;;;;;;;;;;");
    print(status);
    return status;
  }

  static Future<String?> changedPasswordToJson(String login, String password) async {
    Map<String, dynamic> passwordDto;
    passwordDto = {
      "login": login,
      "password": password,
      "display_name": "null",
    };
    var passworJson = jsonEncode(passwordDto);
    return passworJson;
  }

  // Future<Profile> tryGetProfile() async {
  //   var response = await fetchProfile();
  //   print(")))))))))))");
  //   print(response.statusCode);
  //   // if (response.statusCode != 200) return null;
  //
  //   var decodedBody = utf8.decode(response.body.codeUnits);
  //   print(decodedBody);
  //   var profileJson = jsonDecode(decodedBody);
  //
  //   Profile profile;
  //   profile = Profile(
  //     uid: profileJson["uid"],
  //     display_name: profileJson["display_name"],
  //     image: profileJson[faceMedia] != null ? getImageUrl(profileJson[faceMedia]) : "null",
  //     info: profileJson["info"] ?? " ",
  //     tg_link: profileJson["tg_link"] ?? " ",
  //     vk_link: profileJson["vk_link"] ?? " ",
  //   );
  //
  //   return profile;
  // }
  //
  // Future getProfile() async {
  //   var status = await tryGetProfile();
  //   print(status);
  //   if (status == 200) return status;
  //
  //   if (status == 401) {
  //     int status_access = await Authorization.refreshAccessToken();
  //     print(status_access);
  //
  //     if (status_access == 200) return await tryGetProfile();
  //     if (status_access == 401) {
  //       int status_refresh = await Authorization.refreshTokens();
  //       if (status_refresh == 200) return await tryGetProfile();
  //     }
  //   }
  //   print("cvcvcvcvcvcv");
  //   return status;
  // }

  Future tryGetProfile() async {
    var accessToken = await Token.getAccessToken();
    final Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
      'Custom-Header': 'Custom Value',
    };
    var profileUri = Uri.parse('${apiUrl}profile');
    var response = await http.get(profileUri, headers: headers);
    // var response = await fetchProfile();
    return response;
  }

  Future getProfile() async {
    var response = await tryGetProfile();
    var status = response.statusCode;
    print(status);
    print("((((((status))))))");
    // if (status == 200) return status;

    if (status == 401) {
      int status_access = await Authorization.refreshAccessToken();
      print("((((status_access))))");
      print(status_access);

      if (status_access == 200) response = await tryGetProfile();
      else if (status_access == 401) {
        print("(((((88667)))))");
        Token.deleteAccessToken();
        Token.deleteRefreshToken();
        UserDB.deleteAll();
        // int status_refresh = await Authorization.refreshTokens();
        // print("((((status_refresh))))");
        // print(status_refresh);
        // if (status_refresh == 200) response = await tryGetProfile();
      }
    }

    print(response.statusCode);
    print("((((((status))))))");
    if (response.statusCode == 200){
      var decodedBody = utf8.decode(response.body.codeUnits);
      print(decodedBody);
      var profileJson = jsonDecode(decodedBody);

      Profile profile;
      profile = Profile(
        uid: profileJson["uid"],
        display_name: profileJson["display_name"],
        image: profileJson[faceMedia] != null ? getImageUrl(profileJson[faceMedia]) : defaultProfileUrl,
        info: profileJson["info"] ?? " ",
        tg_link: profileJson["tg_link"] ?? " ",
        vk_link: profileJson["vk_link"] ?? " ",
      );

      return profile;
    }
    print("cvcvcvcvcvcv");
    return null;
  }

  static String getImageUrl(int id) {
    return "${apiUrl}media/$id";
  }

  Profile profileFromJson(dynamic profileJson) {
    Profile profile = Profile(
    uid: profileJson["uid"],
    display_name: profileJson["display_name"],
    image: getImageUrl(profileJson["media_id"]) ?? " ",
    info: profileJson["info"] ?? " ",
    tg_link: profileJson["tg_link"] ?? " ",
    vk_link: profileJson["vk_link"] ?? " ",
    );

    return profile;
  }

  Future<http.Response> fetchProfile() async {
    var accessToken = await Token.getAccessToken();
    final Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
      'Custom-Header': 'Custom Value',
    };
    var profileUri = Uri.parse('${apiUrl}profile');
    return http.get(profileUri, headers: headers);
  }

  static Future<Profile?> getProfileId(String login) async {
    var response = await fetchProfileId(login);
    // if (response.statusCode != 200) {
    //   return null;
    // }
    print(response.statusCode);
    print(response.request);
    if (response.statusCode != 200) return null;

    var decodedBody = utf8.decode(response.body.codeUnits);
    var profileJson = jsonDecode(decodedBody);


    print(profileJson);

    Profile? profile = profileIdFromJson(profileJson);

    return profile;
  }

  static Profile profileIdFromJson(dynamic profileJson) {
    String uid = profileJson['uid'];
    print("(((uid)))");
    print(uid);
    Profile profile = Profile(
      uid: profileJson["uid"],
      display_name: profileJson["display_name"] ?? " ",
      image: profileJson[faceMedia] != null ? getImageUrl(profileJson[faceMedia]) : defaultProfileUrl,
      info: profileJson["info"] ?? " ",
      tg_link: profileJson["tg_link"] ?? " ",
      vk_link: profileJson["vk_link"] ?? " ",
    );

    return profile;
  }

  static Future<http.Response> fetchProfileId(String login) async {
    var accessToken = await Token.getAccessToken();
    final Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
      'Custom-Header': 'Custom Value',
    };
    var profileUri = Uri.parse('${apiUrl}profile/$login');
    return http.get(profileUri, headers: headers);
  }
}