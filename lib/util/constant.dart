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
  //My package name
  static final String package = "com.wallchina.goodevening";

  // banner
  static final String banner = "230361571428329_230365004761319";

  // interstitial
  static final String Interstitial = "230361571428329_230364461428040";

  // native
  static final String Native = "230361571428329_230362724761547";

  //banner Native
  static final String BannerNative = "230361571428329_232607371203749";

  //onesignal Id
  static final String onesignal_app_id = "1af00aa0-f040-48ba-871b-9e7f90a70513";

  // counter for Show Inyterstitial
  static int count = 0;

  //this is the path of uploaded image of server where image store
  static final String SERVER_IMAGE_UPFOLDER_CATEGORY =
      "http://dev3pro.com/WallpaperApp00/categories/";

  //this is the path of uploaded image of server where image store
  static final String SERVER_IMAGE_UPFOLDER_THUMB =
      "http://dev3pro.com/WallpaperApp00/images/thumbs/";

  //this url is used to get latest 15 image in 1st tab.here 15 indicate that display latest 15 image if you want change to another then do.
  static final String LATEST_URL =
      "http://dev3pro.com/WallpaperApp00/api.php?latest=1000";

  //this url gives list of category in 2nd tab
  static final String CATEGORY_URL =
      "http://dev3pro.com/WallpaperApp00/api.php";

  //this url gives item of specific category.
  static final String CATEGORY_ITEM_URL =
      "http://dev3pro.com/WallpaperApp00/api.php?cat_id=";

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
  static String prefixstore = 'https://play.google.com/store/apps/details?id=';
}
