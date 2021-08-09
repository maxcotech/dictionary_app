import 'package:dictionary/controllers/controller.dart';
import 'package:dictionary/services/history_service.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:dictionary/helpers/ad_manager.dart';
import 'dart:async';
import 'package:flutter/material.dart' show Orientation;

class HistoryController extends Controller{
  HistoryService hService;
  BannerAd bads;
  Completer completer = new Completer<BannerAd>();

  @override
  void onInit() {
    hService = Get.put(HistoryService());
    this.initAd();
    AdManager.createIntAd(this);
    super.onInit();
  }

  Future<bool> addToHistory(String word) async {
    if(await hService.addToHistory(word) == true){
      this.update();
      return true;
    } else {
      return false;
    }
  }

  void removeFromHistory(String word)async{
    if(await hService.removeFromHistory(word)){
      this.update();
    }
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

  @override
  void onClose() {
    this.bads.dispose();
    super.onClose();
  }

  


}