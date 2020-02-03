class constant {
  //this is the path of uploaded image of server where image store
  static final String SERVER_IMAGE_UPFOLDER_CATEGORY =
      "http://www.dev3pro.com/WallpaperApp00/categories/";

  //this is the path of uploaded image of server where image store
  static final String SERVER_IMAGE_UPFOLDER_THUMB =
      "http://www.dev3pro.com/WallpaperApp00/images/thumbs/";

  //this url is used to get latest 15 image in 1st tab.here 15 indicate that display latest 15 image if you want change to another then do.
  static final String LATEST_URL =
      "http://www.dev3pro.com/WallpaperApp00/api.php?latest=100";
  //this url gives list of category in 2nd tab
  static final String CATEGORY_URL =
      "http://www.dev3pro.com/WallpaperApp00/api.php";
  //this url gives item of specific category.
  static final String CATEGORY_ITEM_URL =
      "http://www.dev3pro.com/WallpaperApp00/api.php?cat_id=";

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
