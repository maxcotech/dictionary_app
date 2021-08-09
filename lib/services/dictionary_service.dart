import 'dart:math';

import 'package:dictionary/models/word_parameter.dart';
import 'package:dictionary/services/db_service.dart';
import 'package:get/get.dart';

class DictionaryService extends GetxService {

  DbService dbService;
  @override
  void onInit() {
    dbService = Get.find<DbService>();
    super.onInit();
  }

  Future<List<Map<String,Object>>> searchWords(String query,{limit:18}) async {
    var response = await dbService.db.rawQuery("SELECT * FROM words WHERE word LIKE '$query%'");
    return response;
  }

  Future<Map<String,dynamic>> getWordByWordParam(WordParameter wordParameter) async {
    var response = <Map<String,dynamic>>[];
    if(wordParameter.parameterType == ParameterType.primaryKey){
      response = await dbService.db.query('words',where:"id = ?",whereArgs:[wordParameter.parameter]);
    } 
    else if(wordParameter.parameterType == ParameterType.word){
      response = await dbService.db.query('words',where:"word = ?",whereArgs:[wordParameter.parameter]);
    } else {
      throw new Exception("Valid Parameter type required.");
    }
    if(response.length > 0){
      return response[0];
    } else {
      return Map<String,dynamic>();
    }
  }

  Future<List<Map<String,dynamic>>> getWordMeaningsByWordId(int id) async {
    var response = await dbService.db.query('word_meanings',where:'word_id = ?',whereArgs:[id]);
    return response;
  }

  Future<int> getTotalNumberOfWords()async{
    /*var response = await dbService.db.query('words',columns:['id']);
    return response.length;*/
    return 121340;
  }

  Future getRandomWordId() async {
    int maxId = await getTotalNumberOfWords();
    Random rand = new Random();
    int generated = rand.nextInt(maxId);
    if(generated > 0){
      return generated;
    } else {
      return 1;
    }
  }

  Future<Map<String,dynamic>> getWordPayloadByWordParameter(WordParameter wparam) async {
    var wordData = await getWordByWordParam(wparam);
    if(wordData['id'] != null){
      var wordMeanings = await getWordMeaningsByWordId(wordData['id']);
      return <String,dynamic>{
        'word_data':wordData,
        'word_meanings':wordMeanings
      };
    } else {
      return <String,dynamic>{};
    }
    
  }

}