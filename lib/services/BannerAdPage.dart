import 'package:yandex_mobileads/mobile_ads.dart';
import 'package:flutter/material.dart';

class BottomBannerAd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int screenWidth = MediaQuery.of(context).size.width.round();

    final BannerAdSize bannerAdSize = BannerAdSize.sticky(width: screenWidth);

    final banner = BannerAd(
      adUnitId: 'demo-banner-yandex',
      adSize: bannerAdSize,
      adRequest: AdRequest(),
      onAdLoaded: () {
        /* Do something */
      },
      onAdFailedToLoad: (error) {
        /* Do something */
      },
    );

    return AdWidget(bannerAd: banner);
  }
}
