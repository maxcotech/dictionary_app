import 'package:dictionary/views/bookmark_view.dart';
import 'package:dictionary/views/history_view.dart';
import 'package:dictionary/views/word_view.dart';
import 'package:get/get.dart';
import 'package:dictionary/views/home_view.dart';

List<GetPage> getPages(){
  return <GetPage>[
    GetPage(name:"/",page:() => HomeView()),
    GetPage(name:'/word_view',page:()=> WordView()),
    GetPage(name:'/history_view',page:()=>HistoryView()),
    GetPage(name:"/bookmark_view",page:()=>BookmarkView())
  ];
}