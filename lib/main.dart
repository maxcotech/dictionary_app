import 'package:dictionary/config/app_constant.dart';
import 'package:dictionary/controllers/bookmark_controller.dart';
import 'package:dictionary/controllers/history_controller.dart';
import 'package:dictionary/services/dictionary_service.dart';
import 'package:dictionary/services/preference_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dictionary/services/db_service.dart';
import 'package:dictionary/config/route_config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await init();
  runApp(MyApp());
}

Future init() async {
  await Get.putAsync<DbService>(() async => await DbService.init());
  await Get.putAsync<PreferenceService>(() async => await PreferenceService.init());
  Get.put(DictionaryService());
  Get.put(HistoryController());
  Get.put(BookmarkController());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: APP_NAME,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      
      ),
      initialRoute: "/",
      getPages: getPages(),

    );
  }
}

