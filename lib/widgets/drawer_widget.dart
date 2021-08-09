import 'package:dictionary/widgets/word_search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dictionary/controllers/drawer_controller.dart' as e;

class DrawerWidget extends StatelessWidget{
  final e.DrawerController controller = Get.put(e.DrawerController());
  @override
  Widget build(BuildContext context){
    return GetBuilder(
      init:e.DrawerController(),
      builder:(_)=>SafeArea(child:Drawer(
      child:Container(
        padding:EdgeInsets.only(top:20),
        color:Colors.black54,
        child:ListView(
        children: _widgetList(context)
      ))
    )));
  }

  List<Widget> _widgetList(BuildContext context){
    return <Widget>[
     
       ListTile(
         leading:Icon(Icons.home),
         title:Text('Home Page'),
         onTap:()=>Get.offAllNamed('/')
       ),
       ListTile(
        leading:Icon(Icons.bookmark),
        title:Text('Bookmarks'),
        onTap:()=>Get.toNamed('/bookmark_view')
      ),
      ListTile(
        leading:Icon(Icons.history),
        title:Text('History'),
        onTap:()=>Get.toNamed('/history_view')
      ),
      ListTile(
        title:Text('Random Word'),
        leading:controller.isLoading? 
          SizedBox(width:20,height:20,child:CircularProgressIndicator(strokeWidth:3)):Icon(Icons.book),
        onTap:controller.openRandomWord
      ),
      ListTile(
        leading:Icon(Icons.search),
        title:Text('Search Word'),
        onTap:(){
          showSearch(context: context, delegate: WordSearchDelegate());
        }
      )
    ];
  }
}