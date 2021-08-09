import 'package:dictionary/controllers/controller.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:dictionary/helpers/ad_manager.dart';
import 'dart:async';
import 'package:flutter/material.dart' show Orientation;

class HomeController extends Controller{
  BannerAd bads;
  Completer completer = new Completer<BannerAd>();
  @override
  void onInit() {
    this.initAd();
    super.onInit();
  }
   void initAd() async {
    this.bads = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      listener: AdListener(onAdLoaded: (Ad ad){completer.complete(ad as BannerAd);}),
      request: AdRequest(),
      size:AdSize.getSmartBanner(Orientation.landscape)
    );
    await bads.load();
  }

  void onClose(){
    this.bads.dispose();
    super.onClose();
  }
}