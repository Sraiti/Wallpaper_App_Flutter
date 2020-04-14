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
  // name
  static final String nameApp = "鲜花照片";

  //My package name
  static final String package = "com.wallchina.flowers";

  static final String fjhg = "Bom Dia";
  // banner
  static final String banner = "756894781441261_758902417907164";

  // interstitial
  static final String Interstitial = "756894781441261_758903871240352";

  // native
  static final String Native = "756894781441261_759233337874072";

  //banner Native
  static final String BannerNative = "586726395384656_586729742050988";

  //onesignal Id
  //static final String onesignal_app_id = "93a9b681-97bd-4fa8-af4c-c0f152cfeffa";

  // counter for Show Inyterstitial
  static int countInter = 4;
  static int countNative = 1;

  //this is the path of uploaded image of server where image store
  static final String SERVER_IMAGE_UPFOLDER_CATEGORY =
      "http://dev3pro.com/WallpaperApp02/categories/";

  //this is the path of uploaded image of server where image store
  static final String SERVER_IMAGE_UPFOLDER_THUMB =
      "http://dev3pro.com/WallpaperApp02/images/thumbs/";

  static final String CATEGORY_IMAGE =
      "http://dev3pro.com/WallpaperApp02/images/";

  //this url gives list of category in 2nd tab
  static final String CATEGORY_URL =
      "http://dev3pro.com/WallpaperApp02/api.php";

  //this url gives item of specific category.
  static final String CATEGORY_ITEM_URL =
      "http://dev3pro.com/WallpaperApp02/api.php?cat_id=";

  static final String LATEST_ARRAY_NAME = "HDwallpaper";
  static final String LATEST_IMAGE_CATEGORY_NAME = "category_name";
  static final String LATEST_IMAGE_URL = "image";

  static final String CATEGORY_ARRAY_NAME = "HDwallpaper";
  static final String CATEGORY_NAME = "category_name";
  static final String CATEGORY_CID = "cid";
  static final String CATEGORY_IMAGE_URL = "category_image";

  static final String aboutUrl = "";

  //for title display in CategoryItemF
  static String CATEGORY_TITLE;
  static String CATEGORY_ID;

  static final String CATEGORY_ITEM_ARRAY = "HDwallpaper";
  static final String CATEGORY_ITEM_CATNAME = "cat_name";
  static final String CATEGORY_ITEM_IMAGEURL = "images";
  static String prefixstore = 'https://play.google.com/store/apps/details?id=';
}
