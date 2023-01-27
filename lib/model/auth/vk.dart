// import 'package:flutter/cupertino.dart';
// import 'package:flutter_login_vk/flutter_login_vk.dart';
//
// class Vk {
//   final vk = VKLogin();
//
//   void signIn() async {
//     if (!vk.isInitialized) {
//       var initialized = await vk.initSdk();
//       if (initialized.isError) {
//         debugPrint(initialized.asError!.error.toString());
//         return;
//       }
//     }
//     final res = await vk.logIn(scope: [
//       VKScope.email,
//     ]);
//     if (res.isError) {
//       final errorRes = res.asError;
//       debugPrint(errorRes!.error.toString());
//       return;
//     }
//     final VKLoginResult data = res.asValue!.value;
//     if (data.isCanceled) {
//       return;
//     }
//     // final VKAccessToken accessToken = data.accessToken!;
//     var profile = await vk.getUserProfile();
//     debugPrint('Your name is ${profile.asValue!.value!.firstName}');
//     debugPrint('Your lastname is ${profile.asValue!.value!.lastName}');
//     debugPrint('Your user id is ${profile.asValue!.value!.userId}');
//     debugPrint('Your photo is ${profile.asValue!.value!.photo200}');
//   }
// }
