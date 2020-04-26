class ImagesGrabber {
  List<ImageItem> imagesList;

  ImagesGrabber({this.imagesList});

  ImagesGrabber.fromJson(Map<String, dynamic> json, List<ImageItem> dbImages) {
    if (json['HDwallpaper'] != null) {
      imagesList = new List<ImageItem>();
      json['HDwallpaper'].forEach(
        (v) {
          ///Filtering The Data to see The Ones how's already exist in the sqllite Database
          /// and make them Favored  by isfav=1
          ImageItem imageItem = new ImageItem.fromJson(v);
          imageItem.isfav = 0;

          ///decode Unicode String To proper String
//          var parts = imageItem.catName.split('u')..removeAt(0);
//          // map from hex string to code point int, and create string
//          imageItem.catName = String.fromCharCodes(
//            parts.map<int>((hex) => int.parse(hex, radix: 16)),
//          );
          // print(imageItem.imageUrl);
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
