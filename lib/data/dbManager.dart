import 'package:flutter_app/models/ImageItem.dart';
import 'package:flutter_app/util/sqlite.dart';

//this class for change favorite color
class ImageDBController {
  ImageItem _tempimage;

  ImageItem get image => _tempimage;

  ImageDBController();

  void changeimage(ImageItem image) {
    this._tempimage = image;
//    notifyListeners();
  }

  void setfav(int fav) {
    _tempimage.isfav = fav;
//    notifyListeners();
  }

  void addToFav(ImageItem _tempimage) {
    DBHelper dbhelper = DBHelper();
    dbhelper.addToFavorites(_tempimage);
  }

  void deletefav(ImageItem _tempimage) {
    DBHelper dbhelper = DBHelper();
    dbhelper.deleteFromFavorites(_tempimage);
  }
}
