
import 'dart:convert';

class Word{
  final int id;
  final String word;
  final List<String> synonyms;
  final List<String> antonyms;

  Word({this.id,this.word,this.synonyms,this.antonyms});

  factory Word.fromMap(Map<String,dynamic> map){
    return Word(
      id:map['id'],
      word: map['word'],
      synonyms: jsonDecode(map['synonyms']) ?? <String>[],
      antonyms: jsonDecode(map['antonyms']) ?? <String>[]
    );
  }
}