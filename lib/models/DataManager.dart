import 'package:flutter_app/models/cat.dart';
import 'package:flutter_app/models/itemImage.dart';
import 'package:flutter_app/util/sqlite.dart';

class DataManager {
  static DataManager Instanse;

  static DataManager getInstance() {
    if (Instanse == null) Instanse = DataManager();
    return Instanse;
  }

  List<itemImage> allFavImages = [];
  List<itemImage> allImage = [];
  List<CatItem> allcats = [];

  CatItem ClickedCat;

  List<itemImage> get images => allImage;

  List<itemImage> get allfav => allImage;

  List<CatItem> get cats => allcats;

  void DeleteAllImages() {
    allImage.clear();
  }

  Future<List<itemImage>> getAllFavImages() async {
    var dbhepler = DBHelper();
    allFavImages = await dbhepler.getFavorites();

    return allFavImages;
  }
}
