import 'package:flutter_app/models/cat.dart';
import 'package:flutter_app/models/itemImage.dart';

class DataManager {
  static DataManager Instanse;

  static DataManager getInstance() {
    if (Instanse == null) Instanse = DataManager();
    return Instanse;
  }

  List allfavorites = [];
  List<itemImage> allImage = [];
  List<CatItem> allcats = [];

  CatItem ClickedCat;

  List<itemImage> get images => allImage;

  List<itemImage> get allfav => allImage;

  List<CatItem> get cats => allcats;

  void DeleteAllImages() {
    allImage.clear();
  }
}
