class ImageItem {
  static ImageItem current;

  String urlImage;
  String CatName;
  int isfav;

  @override
  bool operator ==(other) {
    return (CatName == other.CatName && urlImage == other.urlImage);
  }

  ImageItem();
}
