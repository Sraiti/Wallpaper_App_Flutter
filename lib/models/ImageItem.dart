class ImagesGrabber {
  List<ImageItem> imagesList;

  ImagesGrabber({this.imagesList});

  ImagesGrabber.fromJson(Map<String, dynamic> json, List<ImageItem> dbImages) {
    if (json['HDwallpaper'] != null) {
      imagesList = new List<ImageItem>();
      json['HDwallpaper'].forEach(
        (v) {
          ImageItem imageItem = new ImageItem.fromJson(v);
          imageItem.isfav = 0;
          ImageItem isFavouriteCheck = dbImages.firstWhere(
              (image) =>
                  imageItem.imageUrl + imageItem.catName ==
                  image.imageUrl + image.catName,
              orElse: () => null);
          (isFavouriteCheck == null)
              ? imageItem.isfav = 0
              : imageItem.isfav = 1;
          imagesList.add(imageItem);
        },
      );
    }
  }
}

class ImageItem {
  String imageUrl;
  String catName;
  int isfav;

  ImageItem({this.imageUrl, this.catName, this.isfav});

  ImageItem.fromJson(Map<String, dynamic> json) {
    imageUrl = json['images'];
    catName = json['cat_name'];
  }
}
