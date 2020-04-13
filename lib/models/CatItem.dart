class CategoriesGrabber {
  List<Category> categoriesList;

  CategoriesGrabber({this.categoriesList});

  CategoriesGrabber.fromJson(Map<String, dynamic> json) {
    if (json['HDwallpaper'] != null) {
      categoriesList = new List<Category>();
      json['HDwallpaper'].forEach(
        (v) {
          Category c = new Category.fromJson(v);
          print("CategoryGrabber");
          print(c.categoryName);
          categoriesList.add(c);
        },
      );
    }
  }
}

class Category {
  String cid;
  String categoryName;
  String categoryImage;

  Category({this.cid, this.categoryName, this.categoryImage});

  Category.fromJson(Map<String, dynamic> json) {
    cid = json['cid'];
    categoryName = json['category_name'];
    categoryImage = json['category_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cid'] = this.cid;
    data['category_name'] = this.categoryName;
    data['category_image'] = this.categoryImage;
    return data;
  }
}
