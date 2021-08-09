import 'package:dictionary/controllers/bookmark_controller.dart';
import 'package:dictionary/controllers/controller.dart';
import 'package:dictionary/controllers/history_controller.dart';
import 'package:dictionary/models/word_parameter.dart';
import 'package:dictionary/services/dictionary_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:dictionary/helpers/ad_manager.dart';
import 'package:flutter/material.dart' show Orientation;
import 'package:get/get.dart';
import 'dart:async';


class WordViewController extends Controller{
  DictionaryService dicService;
  WordParameter parameters;
  Map<String,dynamic> wordData;
  List<Map<String,dynamic>> wordMeanings;
  HistoryController hControl;
  BookmarkController bControl;
  BannerAd bads;
  Completer completer = new Completer<BannerAd>();

  @override
  void onInit() async {
    this.setLoading(true);
    this.parameters = Get.arguments as WordParameter;
    this.dicService = Get.find<DictionaryService>();
    this.hControl = Get.find<HistoryController>();
    this.bControl = Get.find<BookmarkController>();
    var result = await dicService.getWordPayloadByWordParameter(this.parameters);
    this.wordData = result['word_data'];
    this.wordMeanings = result['word_meanings'];
    this.setLoading(false);
    if(this.wordData != null) await hControl.addToHistory(this.wordData['word']);
    this.initAd();
    AdManager.createIntAd(this);
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

  Future<void> onClose() async {
    this.bads.dispose();
    this.bads = null;
    super.dispose();
  }

}