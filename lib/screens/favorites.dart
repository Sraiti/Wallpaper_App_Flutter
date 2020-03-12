import 'package:cached_network_image/cached_network_image.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/image.dart';
import 'package:flutter_app/models/itemImage.dart';
import 'package:flutter_app/screens/wallpaper.dart';
import 'package:flutter_app/util/constant.dart';
import 'package:flutter_app/util/sqlite.dart';

class Favorites extends StatelessWidget {
  static final String id = "favorites";
  var dbhelper = DBHelper();
  var alldata = data.getInstance();

  Future<List<itemImage>> getfav() async {
    var dbhepler = DBHelper();
    Future<List<itemImage>> favs = dbhepler.getfavorites();
    return favs;
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width / 2;
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder(
          future: getfav(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done)
              return GridViewFavorites(
                width: _width,
                allfav: snapshot.data,
              );
            else
              return Center(
                child: Container(
                  child: Text('Empty'),
                ),
              );
          },
        ),
      ),
    );
  }
}

class GridViewFavorites extends StatelessWidget {
  const GridViewFavorites({
    Key key,
    @required double width,
    @required this.allfav,
  })  : _width = width,
        super(key: key);

  final double _width;
  final List<itemImage> allfav;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        allfav.length != 0
            ? Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: allfav.length == null ? 0 : allfav.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WallpaperPage(
                                  heroId: index, allimage: allfav),
                            ),
                          );
                        },
                        child: Column(
                          children: <Widget>[
                            Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Container(
                                width: _width,
                                height: 70,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Hero(
                                    tag: index,
                                    child: CachedNetworkImage(
                                      imageUrl: constant
                                              .SERVER_IMAGE_UPFOLDER_CATEGORY +
                                          'bom-dia/' +
                                          allfav[index].urlImage,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          Image.asset(
                                        'assets/images/loading.png',
                                        fit: BoxFit.cover,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            : Container(
                child: Text("Empty"),
              ),
        Container(
          child: FacebookNativeAd(
            placementId: constant.BannerNative,
            adType: NativeAdType.NATIVE_BANNER_AD,
            bannerAdSize: NativeBannerAdSize.HEIGHT_100,
            width: double.infinity,
            backgroundColor: Colors.blue,
            titleColor: Colors.white,
            descriptionColor: Colors.white,
            buttonColor: Colors.deepPurple,
            buttonTitleColor: Colors.white,
            buttonBorderColor: Colors.white,
            listener: (result, value) {
              print("Native Ad: $result --> $value");
            },
          ),
        ),
      ],
    );
  }
}
