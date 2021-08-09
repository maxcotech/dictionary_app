import 'dart:convert';
import 'package:dictionary/controllers/controller.dart';
import 'package:dictionary/services/preference_service.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:dictionary/helpers/ad_manager.dart';
import 'dart:async';
import 'package:flutter/material.dart' show Orientation;

class BookmarkController extends Controller{

  PreferenceService pService;
  Completer completer = new Completer<BannerAd>();
  BannerAd bads;
   @override
  void onInit() {
    pService = Get.find<PreferenceService>();
    this.initAd();
    AdManager.createIntAd(this);
    super.onInit();
  }

  Future<bool> addToBookmark(String word) async {
    String input = word.toLowerCase();
    List bookmark;
    if(pService.prefs.containsKey('bookmark')){
      bookmark = jsonDecode(pService.prefs.getString('bookmark'));
      if(bookmark.contains(input)){
        bookmark.remove(input);
      }
      bookmark.add(input);
    } else {
      bookmark = <dynamic>[];
      bookmark.add(input);
    }
    if(bookmark != null){
      this.update();
      return await pService.prefs.setString('bookmark',jsonEncode(bookmark));
    } else {
      return false;
    }
  }

  List getBookmarks(){
    if(pService.prefs.containsKey("bookmark")){
      List list = jsonDecode(pService.prefs.getString('bookmark'));
      list.sort();
      return list;
    } else {
      return <dynamic>[];
    }
  }

  bool isBookmarkSaved(String str){
    if(pService.prefs.containsKey("bookmark")){
       List list = jsonDecode(pService.prefs.getString('bookmark'));
       if(list.contains(str)){
         return true;
       } 
       return false;
    } else {
      return false;
    }
   
  }

  void toggleBookmark(String data,{List oldList}) async {
    String str = data.toLowerCase();
    if(pService.prefs.containsKey("bookmark")){
      List list = oldList ?? jsonDecode(pService.prefs.getString('bookmark'));
      if(list.contains(str)){
        list.remove(str);
      } else {
        list.add(str);
      }
      if(await pService.prefs.setString('bookmark',jsonEncode(list)) == true){
        print('Updated bookmark');
      }
    } else {
      List list = <String>[];
      list.add(str);
      await pService.prefs.setString("bookmark",jsonEncode(list));
    }
    this.update();
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