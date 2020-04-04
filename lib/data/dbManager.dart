import 'package:flutter/foundation.dart';
import 'package:flutter_app/models/itemImage.dart';
import 'package:flutter_app/util/sqlite.dart';

//this class for change favorite color
class allImage with ChangeNotifier {
  itemImage _tempimage;

  itemImage get image => _tempimage;

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
    dbhelper.addToFavorites(_tempimage);
  }

  void deletefav() {
    DBHelper dbhelper = DBHelper();
    dbhelper.deleteFromFavorites(_tempimage);
  }
}
