class itemImage {
  static itemImage current;

  String urlImage;
  String CatName;
  int isfav;

  @override
  bool operator ==(other) {
    return (CatName == other.CatName && urlImage == other.urlImage);
  }

  itemImage();
}
