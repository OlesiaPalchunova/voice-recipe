import 'package:flutter/cupertino.dart';
import 'package:flutter_login_vk/flutter_login_vk.dart';

class Vk {
  final vk = VKLogin();

  void signIn() async {
    if (!vk.isInitialized) {
      var initialized = await vk.initSdk();
      if (initialized.isError) {
        debugPrint(initialized.asError!.error.toString());
        return;
      }
    }
    final res = await vk.logIn(scope: [
      VKScope.email,
    ]);
    if (res.isError) {
      final errorRes = res.asError;
      debugPrint(errorRes!.error.toString());
      return;
    }
    final VKLoginResult data = res.asValue!.value;
    if (data.isCanceled) {
      return;
    }
    // final VKAccessToken accessToken = data.accessToken!;
    var profile = await vk.getUserProfile();
    debugPrint('Your name is ${profile.asValue!.value!.firstName}');
    debugPrint('Your lastname is ${profile.asValue!.value!.lastName}');
    debugPrint('Your user id is ${profile.asValue!.value!.userId}');
    debugPrint('Your photo is ${profile.asValue!.value!.photo200}');
  }
}

// const vkClientId = '51487030';
// const callbackUrlScheme = 'voicerecipe.ru';
//
// final url = Uri.https('oauth.vk.com', '/authorize', {
//   'response_type': 'token',
//   'client_id': vkClientId,
//   'redirect_uri': callbackUrlScheme,
//   'scope': 'email',
// });
//
// debugPrint('auth...');
// final result = await FlutterWebAuth.authenticate(
//     url: url.toString(), callbackUrlScheme: callbackUrlScheme.toString());
// debugPrint('success');
// final token = Uri.parse(result).queryParameters['token'];
// debugPrint(token);
// final response =
//     await http.post(Uri(scheme: 'https://www.googleapis.com/oauth2/v4/token'), body: {
//   'client_id': googleClientId,
//   'redirect_uri': '$callbackUrlScheme:/',
//   'grant_type': 'authorization_code',
//   'code': code,
// });

// Get the access token from the response
//     final accessToken = jsonDecode(response.body)['access_token'] as String;