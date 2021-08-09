import 'package:dictionary/models/word.dart';

List<Word> convertMapListToWordList(dynamic mapList){
  List<Word> words = <Word>[];
  if(mapList.length > 0){
    for(var item in mapList){
      words.add(item);
    }
  }
  return words;
}