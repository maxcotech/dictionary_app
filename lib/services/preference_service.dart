import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService extends GetxService{
  SharedPreferences _prefs;
  SharedPreferences get prefs => this._prefs;
  
  static Future<PreferenceService> init() async {
    PreferenceService inst = new PreferenceService();
    inst._prefs = await SharedPreferences.getInstance();
    return inst;
  }
}