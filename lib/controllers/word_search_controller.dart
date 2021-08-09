import 'package:dictionary/controllers/controller.dart';
import 'package:dictionary/models/word_parameter.dart';
import 'package:dictionary/services/dictionary_service.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:dictionary/helpers/ad_manager.dart';
import 'package:flutter/material.dart' show Orientation;
import 'dart:async';

class WordSearchController extends Controller{

  BannerAd bads;
  Completer completer = new Completer<BannerAd>();
  DictionaryService dicService;
  @override
  void onInit() {
    this.dicService = Get.find<DictionaryService>();
    this.initAd();
    AdManager.createIntAd(this);
    super.onInit();
  }

  Future<List<Map<String,dynamic>>> searchWord(String query) async {
    List<Map<String,dynamic>> result = await dicService.searchWords(query);
    return result;
  }

  void openWordView(int wordId){
    Get.toNamed(
      '/word_view',
      arguments:WordParameter(parameter:wordId,parameterType:ParameterType.primaryKey),
    );
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