class CatItem {
  CatItem({this.id, this.imageUrl, this.name});
  int id;
  String name;
  String imageUrl;

  @override
  bool operator ==(other) {
    return (other.name == name);
  }
}
