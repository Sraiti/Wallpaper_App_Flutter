import 'package:flutter_app/models/ImageItem.dart';
import 'package:flutter_app/models/cat.dart';
import 'package:flutter_app/util/sqlite.dart';

class DataManager {
  static DataManager Instanse;

  static DataManager getInstance() {
    if (Instanse == null) Instanse = DataManager();
    return Instanse;
  }

  List<ImageItem> allFavImages = [];
  List<ImageItem> allImages = [];
  List<CatItem> allCategories = [];

  CatItem clickedCategory;

  void deleteAllImages() {
    allImages.clear();
    allFavImages.clear();
  }

  Future<List<ImageItem>> getAllFavImages() async {
    DBHelper dbHelper = DBHelper();
    allFavImages = await dbHelper.getFavorites();

    return allFavImages;
  }
}
