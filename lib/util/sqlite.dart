import 'dart:async';
import 'dart:io' as io;

import 'package:flutter_app/models/ImageItem.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  //definal
  Context context;

  final String Table_name = "image";

  static Database db_instance;

//  DBHelper._();
//  static final DBHelper db2 = DBHelper._();

  Future<Database> get db async {
    if (db_instance == null) db_instance = await initDB();
    return db_instance;
  }

  initDB() async {
    io.Directory documentsdirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsdirectory.path, "MyDB.db");
    var db = await openDatabase(path, version: 1, onCreate: onCreatDB);
    return db;
  }

  void onCreatDB(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $Table_name (id INTEGER PRIMARY KEY AUTOINCREMENT , urlimage TEXT , isfav INTEGER , CatName TEXT);');
  }

  Future<List<ImageItem>> getFavorites() async {
    var dbConnection = await db;
    List<Map> list = await dbConnection.rawQuery('SELECT * FROM $Table_name');
    List<ImageItem> favorites = new List();

    for (int i = 0; i < list.length; i++) {
      ImageItem image = new ImageItem();
      //image.Id = list[i]['id'];
      image.imageUrl = list[i]['urlimage'];
      image.catName = list[i]['CatName'];
      image.isfav = list[i]['isfav'];

      favorites.add(image);
    }

    return favorites;
  }

  void addToFavorites(ImageItem image) async {
    var dbConnection = await db;
    String query =
        'INSERT INTO $Table_name (urlimage , isfav , CatName) VALUES(\'${image.imageUrl}\',${image.isfav},\'${image.catName}\')';
    await dbConnection.rawInsert(query);

    /* await dbConnection.transaction((transaction) async {
      return await transaction.rawInsert(query);
    });*/
  }

  void deleteFromFavorites(ImageItem image) async {
    var dbConnection = await db;
    String query =
        'DELETE FROM $Table_name where urlimage like \'${image.imageUrl}\'';
    //await dbConnection.rawInsert(query);
    await dbConnection.transaction(
      (transaction) async {
        return await transaction.rawQuery(query);
      },
    );
  }
}
