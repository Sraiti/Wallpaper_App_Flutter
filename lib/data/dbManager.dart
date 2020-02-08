import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_app/models/itemImage.dart';
import 'package:flutter_app/util/sqlite.dart';

//this class for change favorite color
class allImage with ChangeNotifier {
  itemImage _tempimage;
  itemImage get image => _tempimage;

  List<itemImage> _allfav = [];
  List<itemImage> get favorites => _allfav;

  void changeimage(itemImage image) {
    this._tempimage = image;
    notifyListeners();
  }

  void setfav(int fav) {
    _tempimage.isfav = fav;
    notifyListeners();
  }

  void addToFav() {
    DBHelper dbhelper = DBHelper();
    dbhelper.addToFavoret(_tempimage);
  }

  void deletefav() {
    DBHelper dbhelper = DBHelper();
    dbhelper.deletFromFavoret(_tempimage);
  }
}
