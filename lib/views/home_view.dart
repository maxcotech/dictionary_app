import 'package:dictionary/config/app_constant.dart';
import 'package:dictionary/controllers/home_controller.dart';
import 'package:dictionary/widgets/bad_widget.dart';
import 'package:dictionary/widgets/drawer_widget.dart';
import 'package:dictionary/widgets/word_search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget{
  final HomeController controller = Get.put(HomeController());
  @override 
  Widget build(BuildContext context){
    return GetBuilder(
        init: HomeController(),
        builder:(control) {
        controller.showIntAds();
        return Scaffold(
        drawer: DrawerWidget(),
        appBar:AppBar(
          title:Text(APP_NAME),
          actions:<Widget>[
            IconButton(icon:Icon(Icons.search),onPressed:(){
              showSearch(context: context, delegate: WordSearchDelegate());
            })
          ],),
        body: _body(context)
    );
        }
    );
  }

  Widget _body(BuildContext context){
    return Column(children: [
      Expanded(child:_bodyContent(context)),
      Text('Powered By Maxcotech LTD',style:TextStyle(fontSize:10)),
      BadWidget(completer: controller.completer, bads: controller.bads)
    ],);
  }

  Widget _bodyContent(BuildContext context){
    List<Widget> widgets = this._bodyList(context);
    return ListView.separated(
      itemCount:widgets.length,
      separatorBuilder: (_,index)=>_listSeparator(),
      itemBuilder:(_,index) => widgets[index]
    );
  }
  Widget _listSeparator(){
    return Container(
      height:6,
      width:Get.size.width,
      color:Colors.blueGrey.withOpacity(0.3)
    );
  }
  List<Widget> _bodyList(BuildContext context){
    return <Widget>[
      ListTile(
        leading:CircleAvatar(child:Icon(Icons.bookmark)),
        title:Text('Bookmarks'),
        onTap:()=>Get.toNamed('/bookmark_view')
      ),
      ListTile(
        leading:CircleAvatar(child:Icon(Icons.history)),
        title:Text('History'),
        onTap:()=>Get.toNamed('/history_view')
      ),
      ListTile(
        leading:CircleAvatar(child:Icon(Icons.book)),
        title:Text('Random Word'),
        onTap:controller.openRandomWord
      ),
       ListTile(
        leading:CircleAvatar(child:Icon(Icons.search)),
        title:Text('Search Word'),
        onTap:(){
          showSearch(context: context, delegate: WordSearchDelegate());
        }
      )
    ];
  }
}