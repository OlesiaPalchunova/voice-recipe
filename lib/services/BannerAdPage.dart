import 'package:yandex_mobileads/mobile_ads.dart';
import 'package:flutter/material.dart';

class BottomBannerAd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int screenWidth = MediaQuery.of(context).size.width.round();
    int screenHeight = (MediaQuery.of(context).size.height  * .08).round();

    final BannerAdSize bannerAdSize = BannerAdSize.inline(width: screenWidth, maxHeight: screenHeight);
    // final BannerAdSize bannerAdSize = BannerAdSize.sticky(width: screenWidth);

    final banner = BannerAd(
      // adUnitId: 'R-M-3964939-1',
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

    // return SizedBox();
    return AdWidget(bannerAd: banner);
  }
}
