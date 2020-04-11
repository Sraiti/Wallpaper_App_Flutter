import 'package:flutter_app/models/CatItem.dart';
import 'package:flutter_app/models/ImageItem.dart';
import 'package:flutter_app/util/sqlite.dart';

class DataManager {
  static DataManager Instanse;

  static DataManager getInstance() {
    if (Instanse == null) Instanse = DataManager();
    return Instanse;
  }

  List<ImageItem> allFavImages = [];
  List<ImageItem> allImages = [];
  List<Category> allCategories = [];

  Category clickedCategory;

  void deleteAllImages() {
    allImages.clear();
  }

  Future<List<ImageItem>> getAllFavImages() async {
    DBHelper dbHelper = DBHelper();
    allFavImages = await dbHelper.getFavorites();
    return allFavImages;
  }
}
