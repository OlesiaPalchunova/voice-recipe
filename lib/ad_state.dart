import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

class AdState {
  AdState({required this.initialization});
  Future<InitializationStatus> initialization;

  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else {
      return 'ca-app-pub-3940256099942544/2934735716';
    }
  }

  AdListener get adListener => _adListener;

  AdListener _adListener = AdListener(
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    onAdFailedToLoad: (Ad ad, LoadAdError error){
      ad.dispose();
      print('Ad failed to liad: $error');
    },
    onAdOpened: (Ad ad) => print('Ad opened.'),
    onAdClosed: (Ad ad) => print('Ad closed.'),
    onApplicationExit: (Ad ad) => print('Left application.'),
  );
}