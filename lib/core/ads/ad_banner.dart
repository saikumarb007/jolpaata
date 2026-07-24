import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// AdMob banner. Ads are the only network use in the app — they load when
/// online and silently render nothing when offline, so the offline experience
/// is never blocked.
///
// ponytail: hard-coded to Google's official TEST ad unit ids. Swap
// _bannerUnitId for your real AdMob unit ids before release, and set your real
// app id in AndroidManifest.xml / iOS Info.plist.
class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  static String get _bannerUnitId => Platform.isIOS
      ? 'ca-app-pub-3940256099942544/2934735716' // iOS test banner
      : 'ca-app-pub-3940256099942544/6300978111'; // Android test banner

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _ad = BannerAd(
      adUnitId: AdBanner._bannerUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _loaded = true),
        onAdFailedToLoad: (ad, _) => ad.dispose(), // offline / no fill: hide
      ),
    )..load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _ad == null) return const SizedBox.shrink();
    return SizedBox(
      width: _ad!.size.width.toDouble(),
      height: _ad!.size.height.toDouble(),
      child: AdWidget(ad: _ad!),
    );
  }
}
