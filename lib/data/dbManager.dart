import 'package:flutter_app/models/ImageItem.dart';
import 'package:flutter_app/util/sqlite.dart';

//this class for change favorite color
class ImageDBController {
  ImageDBController();
  void addToFav(ImageItem _tempimage) {
    DBHelper dbhelper = DBHelper();
    dbhelper.addToFavorites(_tempimage);
  }

  void deletefav(ImageItem _tempimage) {
    DBHelper dbhelper = DBHelper();
    dbhelper.deleteFromFavorites(_tempimage);
  }
}
