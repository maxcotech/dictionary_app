import 'dart:convert';
import 'package:dictionary/config/app_constant.dart';
import 'package:dictionary/controllers/word_view_controller.dart';
import 'package:dictionary/models/word_parameter.dart';
import 'package:dictionary/widgets/bad_widget.dart';
import 'package:dictionary/widgets/circular_loader.dart';
import 'package:dictionary/widgets/drawer_widget.dart';
import 'package:dictionary/widgets/word_search_delegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WordView extends StatelessWidget{
  final WordViewController controller = Get.put(WordViewController(),tag:(Get.arguments as WordParameter).parameter.toString());
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      drawer: DrawerWidget(),
      appBar:AppBar( 
        title:Text(APP_NAME),
        actions:<Widget>[
           IconButton(icon:Icon(Icons.search),onPressed:(){
              showSearch(context: context, delegate: WordSearchDelegate());
            })
        ]
      ),
      body:GetBuilder(
        tag:(Get.arguments as WordParameter).parameter?.toString(),
        init:controller,
        builder:(_){
          controller.showIntAds();
          if(controller.isLoading == true){
            return Center(child:CircularLoader());
          } else if(controller.wordData == null){
            return Center(child:Text('Sorry, This term is not available.'));
          }
          return _body();//649959
        }
      )
    );
  }

  Widget _body(){
    return Column(children: [
      _header(),
      Expanded(child:_bodyContent()),
      BadWidget(completer: controller.completer, bads: controller.bads)
    ],);
  }
  Widget _header(){
    return ListTile(
      tileColor:Colors.blueGrey.withOpacity(0.2),
      title:Text(controller.wordData['word'].toString().capitalizeFirst),
      trailing:IconButton(
        icon:Icon(CupertinoIcons.star_fill,
        color:controller.bControl.isBookmarkSaved(controller.wordData['word'])? Colors.yellow:Colors.white),
      onPressed: (){
        controller.bControl.toggleBookmark(controller.wordData['word']);
        controller.update();
      },
      )
    );
  }
  Widget _bodyContent(){
    return ListView(
      padding:EdgeInsets.symmetric(horizontal:10,vertical:10),
      physics:BouncingScrollPhysics(),
      children: <Widget>[
        wordMeanings(),
        wordRelationWidget(key:"antonyms",title:"Antonyms"),
        wordRelationWidget(key:"synonyms",title:"Synonyms")

      ],);
  }

  Widget wordRelationWidget({String key = "antonyms",String title = "Antonyms"}){
    List<dynamic> relations = jsonDecode(controller.wordData[key]);
    if(relations == null || relations.length == 0 ){
      return Container();
    } else {
      List<Widget> widgets = <Widget>[];
      widgets.add(SizedBox(height:10));
      widgets.add(Text(title,style:TextStyle(fontSize:16)));
      widgets.add(SizedBox(height:10));
      widgets.addAll(relations.map((relation){
          return relationItem(item:relation as String);
        }).toList());
      return firstLayerContainer(child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:widgets
      ));
    }
  }

  Widget relationItem({String item}){
    return GestureDetector(
      onTap:() => Get.toNamed('/word_view',
      preventDuplicates: false,
      arguments:WordParameter(
        parameter:item.toLowerCase(),
        parameterType:ParameterType.word,
        )),
      child:Padding(
        child:Text(item,style:TextStyle(color:Colors.blue)),
        padding:EdgeInsets.symmetric(vertical:10),
      )
    );
  }
  Widget wordMeanings(){

    if(controller.wordMeanings.length > 0){
      int count = 0;
      return Column(
        mainAxisSize:MainAxisSize.min,
        children:controller.wordMeanings.map((Map<String,dynamic> item){
          count++;
          return wordMeaning(item,count);
        }
        ).toList().cast<Widget>()
      );
    } else {
      return Container();
    }
  }
  Widget wordMeaning(Map<String,dynamic> item,int index){
    var examples = item['examples'] != null? jsonDecode(item['examples']) : <String>[];
    return firstLayerContainer(
      child:Column(
        mainAxisSize:MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(index.toString()+")  "+item['word_type'],style:TextStyle(fontSize:16)),
          SizedBox(height:10),
          Text(item['meaning'].toString().capitalizeFirst+"."),
          SizedBox(height:10),
          examples.length > 0?Text('Examples',style:TextStyle(fontWeight:FontWeight.bold)):Container(),
          examplesWidget(examples)
          
      ],)
    );
  }
  Widget examplesWidget(List<dynamic> examItems){
    if(examItems.length > 0){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: examItems.map(
        (item) => badge(text:(item as String).capitalizeFirst + ".")
      ).toList().cast<Widget>(),);
    } else {
      return Container();
    }
  }
  Widget badge({String text}){
    return Container(
      child:Text(text),
      decoration:BoxDecoration(
        borderRadius:BorderRadius.circular(10),
        color:Colors.blueGrey.withOpacity(0.3),
      ),
      padding:EdgeInsets.symmetric(horizontal: 10,vertical:5),
      margin:EdgeInsets.symmetric(vertical:5)
    );
  }
  Widget firstLayerContainer({Widget child}){
    return Container(
      padding:EdgeInsets.all(10),
      margin:EdgeInsets.only(bottom:10),
      width:Get.size.width,
      child:child,
      decoration:BoxDecoration( 
        color:Colors.blueGrey.withOpacity(0.1),
        borderRadius:BorderRadius.circular(8)
      )
    );
  }
}