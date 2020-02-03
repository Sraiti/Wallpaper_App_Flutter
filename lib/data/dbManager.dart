import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_app/models/itemImage.dart';
import 'package:flutter_app/util/sqlite.dart';

class DataProvider with ChangeNotifier {
  itemImage current;
  Future<List<itemImage>> getfav() async {
    var dbhepler = DBHelper();
    Future<List<itemImage>> favs = dbhepler.getfavorites();
    return favs;
  }

  void addToFav(Image) {
    DBHelper dbhelper = DBHelper();
    dbhelper.addToFavoret(Image);
    notifyListeners();
  }

  void deletefav(Image) {
    DBHelper dbhelper = DBHelper();
    dbhelper.deletFromFavoret(Image);
    notifyListeners();
  }

  itemImage setcurrentImage(Image) {
    this.current = Image;
    notifyListeners();
    return Image;
  }
}
