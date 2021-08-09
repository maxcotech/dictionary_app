import 'dart:convert';

import 'package:dictionary/services/preference_service.dart';
import 'package:get/get.dart';

class HistoryService extends GetxService{
  PreferenceService pService;
  @override
  void onInit() {
    pService = Get.find<PreferenceService>();
    super.onInit();
  }

  List getHistory(){
    if(pService.prefs.containsKey("history")){
      List list = jsonDecode(pService.prefs.getString('history'));
      list = list.reversed.toList();
      return list;
    } else {
      return <dynamic>[];
    }
  }

  Future<bool> removeFromHistory(String str,{List oldList}) async {
    List list = oldList ?? jsonDecode(pService.prefs.getString('history'));
    if(list.contains(str)){
      list.remove(str);
    }
    return await pService.prefs.setString('history',jsonEncode(list));
  }

  Future<bool> addToHistory(String word) async {
    String input = word.toLowerCase();
    List history;
    if(pService.prefs.containsKey('history')){
      history = jsonDecode(pService.prefs.getString('history'));
      if(history.contains(input)){
        history.remove(input);
      }
      history.add(input);
    } else {
      history = <dynamic>[];
      history.add(input);
    }
    if(history != null){
      return await pService.prefs.setString('history',jsonEncode(history));
    } else {
      return false;
    }
  }
}