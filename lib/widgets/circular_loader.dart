import 'package:flutter/material.dart';

class CircularLoader extends StatelessWidget{
  @override 
  Widget build(BuildContext context){
    return SizedBox(
      width:60,
      height:60,
      child:CircularProgressIndicator.adaptive(strokeWidth:3));
   }
}