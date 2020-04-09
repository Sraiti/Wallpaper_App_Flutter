import 'package:cached_network_image/cached_network_image.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/DataManager.dart';
import 'package:flutter_app/models/ImageItem.dart';
import 'package:flutter_app/screens/ImagesViewer.dart';
import 'package:flutter_app/util/constant.dart';

class Favorites extends StatelessWidget {
  static final String id = "favorites";
  DataManager alldata = DataManager.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text("Favorites List"),
      ),
      body: Container(
        color: Colors.white,
        child: FutureBuilder(
          future: alldata.getAllFavImages(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done)
              return GridViewFavorites(
                allFavoriteImages: snapshot.data,
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
  const GridViewFavorites({this.allFavoriteImages});

  final List<ImageItem> allFavoriteImages;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        allFavoriteImages.length != 0
            ? Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: allFavoriteImages.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ImagesViewer(
                                  images: allFavoriteImages,
                                  imageID: index,
                                ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4.0),
                            child: CachedNetworkImage(
                              imageUrl:
                              constant.SERVER_IMAGE_UPFOLDER_CATEGORY +
                                  allFavoriteImages[index].CatName +
                                  '/' +
                                  allFavoriteImages[index].urlImage,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                    height: 80,
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
                    );
                  },
                ),
              )
            : Expanded(
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  child: Image(
                    image: AssetImage('assets/images/icon_empty2.png'),
                  ),
                ),
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
