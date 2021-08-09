import 'package:dictionary/controllers/bookmark_controller.dart';
import 'package:dictionary/models/word_parameter.dart';
import 'package:dictionary/widgets/bad_widget.dart';
import 'package:dictionary/widgets/circular_loader.dart';
import 'package:dictionary/widgets/drawer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookmarkView extends StatelessWidget{
  final BookmarkController controller = Get.find<BookmarkController>();
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      drawer:DrawerWidget(),
      appBar:AppBar(title:Text('Bookmarks')),
      body:GetBuilder( 
        init:BookmarkController(),
        builder:(_){
          controller.showIntAds();
          return _body();
        }
      )
    );
  }

  Widget _body(){
    return Column(children: [
      Expanded(child:_bodyContent()),
      BadWidget(completer: controller.completer, bads: controller.bads)
    ],);
  }

  Widget _bodyContent(){
    List data = controller.getBookmarks();
    if(controller.isLoading == true){
      return Center(child:CircularLoader());
    }
    else if(data == null || data.length == 0){
      return Center(child:Text("You haven't saved any bookmark yet."));
    } else {
      return ListView.separated( 
        physics: BouncingScrollPhysics(),
        separatorBuilder: (_,index)=>Divider(),
        itemCount:data.length,
        itemBuilder:(_,index){
          String word = data[index] as String;
          return ListTile(
            onTap:()=>Get.toNamed('/word_view',arguments:WordParameter(
              parameterType:ParameterType.word,
              parameter:word.toLowerCase())),
            title:Text(word.capitalizeFirst),
            trailing:IconButton(
              onPressed:()=>controller.toggleBookmark(word),
              icon:Icon(Icons.close))
        );}
      );
    }
  }
}