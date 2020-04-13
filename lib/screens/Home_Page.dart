import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/DataManager.dart';
import 'package:flutter_app/models/ImageItem.dart';
import 'package:flutter_app/screens/ImagesViewer.dart';
import 'package:flutter_app/screens/MasterScreen.dart';
import 'package:flutter_app/util/DarkThemeProvider.dart';
import 'package:flutter_app/util/constant.dart';
import 'package:flutter_app/util/util.dart';
import 'package:flutter_app/util/widgets.dart';

import 'Favorites_Page.dart';

class HomePage extends StatefulWidget {
  static final String id = "homepage";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DataManager alldata = DataManager.getInstance();

  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    loadInterstitialAd();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
//    nativeAd = NativeAd();
//    _loadInter();

    return Scaffold(
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: MyDrawer(),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            ShowMore(
              text: 'Favorites',
              haveButton: true,
              onTap: () {
                constant.countInter++;
                constant.countInter % 7 == 0
                    ? showInterstitialAd()
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Favorites(),
                        ),
                      );
              },
            ),
            FavoriteSlider(
              dataManger: alldata,
            ),
            getBannerFB(),
            ShowMore(
              text: alldata.clickedCategory.categoryName,
              haveButton: false,
            ),
            Latest(
              dataManger: alldata,
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteSlider extends StatefulWidget {
  const FavoriteSlider({this.dataManger});

  final DataManager dataManger;

  @override
  _FavoriteSliderState createState() => _FavoriteSliderState();
}

class _FavoriteSliderState extends State<FavoriteSlider> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.dataManger.getAllFavImages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<ImageItem> images = snapshot.data ?? [];
          return Container(
              child: images.length != 0
                  ? CarouselSlider.builder(
                      itemCount: images.length,
                      viewportFraction: 0.3,
                      autoPlay: true,
                      height: 120.0,
                      itemBuilder: (BuildContext context, int itemIndex) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Stack(
                                children: <Widget>[
                                  Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ImagesViewer(
                                              imageID: itemIndex,
                                              images: images,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 120,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          child: CachedNetworkImage(
                                            imageUrl: constant
                                                    .SERVER_IMAGE_UPFOLDER_CATEGORY +
                                                images[itemIndex].catName +
                                                '/' +
                                                images[itemIndex].imageUrl,
                                            imageBuilder:
                                                (context, imageProvider) =>
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
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      })
                  : Container(
                      width: 100.0,
                      height: 100.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Image(
                            image: AssetImage('assets/images/icon_empty2.png'),
                          ),
                        ],
                      ),
                    ));
        } else
          return Center(
            child: Container(
              child: Text('Empty'),
            ),
          );
      },
    );
  }
}

class Latest extends StatelessWidget {
//  int length = 37;
  Latest({this.dataManger});

  final DataManager dataManger;
  bool isload = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: MediaQuery.of(context).size.height,
      child: Expanded(
        child: dataManger.allImages.length != 0
            ? GridView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: dataManger.allImages.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      print("HomePage Url");
                      print(constant.SERVER_IMAGE_UPFOLDER_CATEGORY +
                          dataManger.allImages[index].catName
                              .replaceAll(' ', '%20') +
                          '/' +
                          dataManger.allImages[index].imageUrl);
                      constant.countInter++;
                      constant.countInter % 7 == 0
                          ? showInterstitialAd()
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ImagesViewer(
                                    imageID: index,
                                    images: dataManger.allImages,
                                  );
                                },
                              ),
                            );
                    },
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 90,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          child: Hero(
                            tag: dataManger.allImages[index].imageUrl +
                                dataManger.allImages[index].catName,
                            child: CachedNetworkImage(
                              imageUrl:
                                  constant.SERVER_IMAGE_UPFOLDER_CATEGORY +
                                      dataManger.clickedCategory.categoryName
                                          .replaceAll(' ', '%20') +
                                      '/' +
                                      dataManger.allImages[index].imageUrl,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              placeholder: (context, url) => Image.asset(
                                  'assets/images/loading.png',
                                  fit: BoxFit.contain),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            : Container(
                height: double.infinity,
                width: double.infinity,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text("Please check your Internet Network!"),
                      FlatButton(
                        color: Colors.black12,
                        child: Text(
                          'try again',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: 'good2',
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MasterPage(),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
