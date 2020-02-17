import 'package:flutter/services.dart';

const String channel = 'my_flutter_wallpaper';
const methodChannel = MethodChannel(channel);

/// Set image as wallpaper
/// Arguments: [List] of [String]s, is path of image file, start from folder in external storage directory
/// Return   : a [String] when success or [PlatformException] when failed
/// Example:
/// path of image: 'external storage directory'/flutterImages/image.png
///   methodChannel.invokeMethod(
///      setWallpaper,
///      <String>['flutterImages', 'image.png'],
///   );
const String setWallpaper = 'setWallpaper';

/// Scan image file, after scan, we can see image in gallery
/// Arguments: [List] of [String]s, is path of image file, start from folder in external storage directory
/// Return   : a [String] when success or [PlatformException] when failed
/// Example:
/// path of image: 'external storage directory'/flutterImages/image.png
///   methodChannel.invokeMethod(scanFile, <String>[
///     'flutterImages',
///     'image.png'
///   ]);
const String scanFile = 'scanFile';

/// Share image to facebook
/// Arguments: [String], it is image url
/// Return   : [Null]
/// Example:
/// methodChannel.invokeMethod(shareImageToFacebook, url);
const String shareImageToFacebook = 'shareImageToFacebook';

/// Resize image
/// Arguments: [Map], keys is [String]s, values is dynamic type
/// Return   : a [Uint8List] when success or [PlatformException] when failed
/// Example:
/// final Uint8List outBytes = await methodChannel.invokeMethod(
///   resizeImage,
///   <String, dynamic>{
///     'bytes': bytes,
///     'width': 720,
///     'height': 1280,
///   },
/// );
const String resizeImage = 'resizeImage';

class constant {
  // banner
  static final String banner = "422795005331940_422800488664725";
  // interstitial
  static final String Interstitial = "422795005331940_422800488664725";
  // native
  static final String Native = "YOUR_PLACEMENT_ID";
  //banner Native
  static final String BannerNative = "YOUR_PLACEMENT_ID";

  // counter for Show Inyterstitial
  static int count = 0;
  //this is the path of uploaded image of server where image store
  static final String SERVER_IMAGE_UPFOLDER_CATEGORY =
      "http://dev3pro.com/brazildomdia/categories/";

  //this is the path of uploaded image of server where image store
  static final String SERVER_IMAGE_UPFOLDER_THUMB =
      "http://dev3pro.com/brazildomdia/images/thumbs/";

  //this url is used to get latest 15 image in 1st tab.here 15 indicate that display latest 15 image if you want change to another then do.
  static final String LATEST_URL =
      "http://dev3pro.com/brazildomdia/api.php?latest=1000";

  //this url gives list of category in 2nd tab
  static final String CATEGORY_URL = "http://dev3pro.com/brazildomdia/api.php";

  //this url gives item of specific category.
  static final String CATEGORY_ITEM_URL =
      "http://dev3pro.com/brazildomdia/api.php?cat_id=";

  static final String LATEST_ARRAY_NAME = "HDwallpaper";
  static final String LATEST_IMAGE_CATEGORY_NAME = "category_name";
  static final String LATEST_IMAGE_URL = "image";

  static final String CATEGORY_ARRAY_NAME = "HDwallpaper";
  static final String CATEGORY_NAME = "category_name";
  static final String CATEGORY_CID = "cid";
  static final String CATEGORY_IMAGE_URL = "category_image";

  //for title display in CategoryItemF
  static String CATEGORY_TITLE;
  static String CATEGORY_ID;

  static final String CATEGORY_ITEM_ARRAY = "HDwallpaper";
  static final String CATEGORY_ITEM_CATNAME = "cat_name";
  static final String CATEGORY_ITEM_IMAGEURL = "images";
}
