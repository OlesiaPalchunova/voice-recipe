import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:voice_recipe/ad_state.dart';
import 'package:voice_recipe/services/auth/Token.dart';
import 'package:voice_recipe/services/db/user_db.dart';
import 'package:voice_recipe/voice_recipe_app.dart';
import 'config/config.dart';
import 'model/collections_info.dart';
import 'model/sets_info.dart';
import 'services/local_notice_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

final adStateProvider = ScopedProvider<AdState>((ref) {
  throw UnimplementedError();
});

Future<void> main() async {
  var widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // run that to show native splash screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  LocalNoticeService().setup();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  ); // we need to wait for because user information may be important for app
  if (Config.isWeb) {
    Routemaster.setPathUrlStrategy(); // remove # (useless fragment) from url
  }
  await Config.init(); // define whether app should have light theme or dark
  // NativeAds.initialize();
  WidgetsFlutterBinding.ensureInitialized();
  final adsInitialization = MobileAds.instance.initialize();
  final adState = AdState(initialization: adsInitialization);
  runApp(
    ProviderScope(
      overrides: [
        adStateProvider.overrideWithValue(adState)
      ],
      child:VoiceRecipeApp()
    )
  );
  FlutterNativeSplash.remove();
  Token.init();
  await UserDB.init();
  CollectionsInfo.init();
  CollectionsSet c = CollectionsSet(id: 0, name: "");
  c.initSelections();
}
