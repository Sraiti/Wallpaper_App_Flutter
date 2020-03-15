import 'package:flutter_app/models/cat.dart';
import 'package:flutter_app/models/itemImage.dart';

class data {
  static data Instanse;

  static data getInstance() {
    if (Instanse == null) Instanse = data();
    return Instanse;
  }

  List allfavorites = [];
  List<itemImage> allImage = [];
  List<catItem> allcats = [];

  List<itemImage> get images => allImage;

  List<itemImage> get allfav => allImage;

  List<catItem> get cats => allcats;
}
