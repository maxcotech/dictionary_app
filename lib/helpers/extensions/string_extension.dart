import 'package:get/get.dart';

extension StringUtil on String{
  String capitalizeAll(){
    if(this.contains(" ")){
      List<String> words = this.split(" ");
      var newList = words.map((item)=>item.capitalize).toList();
      return newList.join(" ");
    } 
    else if(this.contains(".")){
      List<String> words = this.split(".");
      var newList = words.map((item)=>item.capitalize).toList();
      return newList.join(".");
    }
    else {
      return this.capitalize;
    }
  }

  String capitalizeFirst(){
    var strList = this.split("");
    var firstLetter = strList.first.toUpperCase();
    strList.first = firstLetter;
    return strList.join();
    
  }

  
}