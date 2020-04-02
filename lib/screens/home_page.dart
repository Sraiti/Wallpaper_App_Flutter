import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/DataManager.dart';
import 'package:flutter_app/models/itemImage.dart';
import 'package:flutter_app/screens/splash.dart';
import 'package:flutter_app/screens/wallpaper.dart';
import 'package:flutter_app/util/constant.dart';
import 'package:flutter_app/util/sqlite.dart';
import 'package:flutter_app/util/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'favorites.dart';

class homepage extends StatelessWidget {
  static final String id = "homepage";
  var alldata = DataManager.getInstance();

  ///Facebook ADS Stuff
//  NativeAd nativeAd;
//  bool isload = false;
//
//  FacebookInterstitialAd _loadInter() {
//    FacebookInterstitialAd interstitialAd = FacebookInterstitialAd();
//    FacebookInterstitialAd.loadInterstitialAd(
//      placementId: constant.Interstitial,
//      listener: (result, value) {
//        if (result == InterstitialAdResult.LOADED) isload = true;
//      },
//    );
//
//    return interstitialAd;
// }

  Widget buildBottomSheet(BuildContext) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
          stops: [0.2, 1],
          colors: [Colors.blue.shade200, Colors.blueAccent.shade700],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: NativeAd(),
          ),
          Text(
            "Are You Sure You Want To Quit ?",
            style: TextStyle(
              fontSize: 16.0,
              fontFamily: 'good2',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton.icon(
                onPressed: () {
                  alldata.DeleteAllImages();
                  Navigator.pop(BuildContext, true);
                },
                label: Text(
                  'Exit',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.amber,
                ),
                color: Colors.black45,
              ),
              FlatButton.icon(
                onPressed: () async {
                  String url = constant.prefixstore + constant.package;
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                  Navigator.pop(BuildContext, false);
                },
                label: Text(
                  'Rate',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                icon: Icon(
                  Icons.stars,
                  color: Colors.amber,
                ),
                color: Colors.black45,
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<bool> _onBackPressed(context) {
    print("alldata :ClickedCat  " + alldata.ClickedCat.toString());
    print(" alldata: allImage  " + alldata.allImage.toString());

    return showModalBottomSheet(context: context, builder: buildBottomSheet);
  }

  @override
  Widget build(BuildContext context) {
//    nativeAd = NativeAd();
//    _loadInter();
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        body: SafeArea(
          child: Column(children: <Widget>[
            ShowMore(
                text: 'Favorites',
                haveButton: true,
                onTap: () {
                  constant.count++;
                  constant.count % 3 == 0
                      ? FacebookInterstitialAd.showInterstitialAd(delay: 0)
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Favorites(),
                          ),
                        );
                }),
            FavoriteSlider(),
            facebookadBanner(),
            ShowMore(
              text: alldata.ClickedCat.name,
              haveButton: false,
            ),
            Latest(),
          ]),
        ),
      ),
    );
  }
}

class FavoriteSlider extends StatelessWidget {
  const FavoriteSlider({
    Key key,
    @required this.allfav,
  }) : super(key: key);

  final List<itemImage> allfav;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getfav(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<itemImage> images = snapshot.data ?? [];
          return Container(
              child: images.length != 0
                  ? CarouselSlider.builder(
                  itemCount: images.length,
                  viewportFraction: 0.3,
                  autoPlay: true,
                  height: 100.0,
                  itemBuilder: (BuildContext context, int itemIndex) {
                    return Builder(
                      builder: (BuildContext context) {
                        DataManager alldata = DataManager.getInstance();

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: <Widget>[
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            WallpaperPage(
                                              heroId: itemIndex,
                                              allimage: images,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 100,
                                    child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(8.0),
                                      child: CachedNetworkImage(
                                        imageUrl: constant
                                            .SERVER_IMAGE_UPFOLDER_CATEGORY +
                                            images[itemIndex].CatName +
                                            '/' +
                                            snapshot
                                                .data[itemIndex].urlImage,
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

class Latest extends StatefulWidget {
  @override
  _LatestState createState() => _LatestState();
}

class _LatestState extends State<Latest> {
  ScrollController _scrollController;

//  int length = 37;
  bool isload = true;
  var alldata = DataManager.getInstance();

//
//  _scrollListener() {
//    if (alldata.allImage.length < length) {
//      length = alldata.allImage.length;
//
//      return;
//    }
//
//    if (_scrollController.position.pixels >
//        _scrollController.position.maxScrollExtent - 200)
//      setState(() {
//        length += 30;
//      });
//  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    FacebookAudienceNetwork.init(
//        testingId: "e6d67e88-aced-4e6f-b392-79d9d6e9b676");
//    print("initiii $length");
//    _scrollController = new ScrollController(
//      // NEW
//      initialScrollOffset: 0.0, // NEW
//      keepScrollOffset: true, // NEW
//    );
//    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: MediaQuery.of(context).size.height,
      child: Expanded(
        child: alldata.allImage.length != 0
            ? GridView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
          itemCount: alldata.allImage.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: GestureDetector(
                      onTap: () {
                        constant.count++;
                        constant.count % 7 == 0
                            ? FacebookInterstitialAd.showInterstitialAd(
                                delay: 0)
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WallpaperPage(
                                      heroId: index,
                                      allimage: alldata.allImage),
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
                              width: MediaQuery.of(context).size.width / 2,
                              height: 70,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Hero(
                                  tag: index,
                                  child: CachedNetworkImage(
                                    imageUrl: constant
                                            .SERVER_IMAGE_UPFOLDER_CATEGORY +
                                        alldata.ClickedCat.name
                                            .replaceAll(' ', '%20') +
                                        '/' +
                                        alldata.allImage[index].urlImage,
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
                        ],
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
                              builder: (context) => splash(),
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

class ScreenArguments {
  final int heroId;
  final List<itemImage> allimage;

  ScreenArguments(this.heroId, this.allimage);
}

Future<List<itemImage>> getfav() async {
  var dbhepler = DBHelper();
  List<itemImage> favs = await dbhepler.getfavorites();

  return favs;
}
