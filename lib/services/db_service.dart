import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class DbService extends GetxService{
  Database _db;
  static final String databaseFile = "dictionary.db";
  Database get db => this._db;
  void setDb(Database val){
    this._db = val;
  }
  static Future<DbService> init() async {
    String dbPaths = await getDatabasesPath();
    DbService dbService = new DbService();
    String dbPath = join(dbPaths,databaseFile);
    if(await databaseExists(dbPath) == false){
      await DbService.createDatabaseFromAsset(dbPath);
    }
    dbService.setDb(await openDatabase(dbPath,readOnly:true));
    return dbService;
  }

  static Future createDatabaseFromAsset(String dbPath) async {
    try{
      await Directory(dirname(dbPath)).create(recursive:true);
      ByteData data = await rootBundle.load("assets/db/$databaseFile");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes,data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes,flush:true);
    }
    catch(e,stack){
      print(stack.toString());
      print(e.toString());
    }
    
  }
}