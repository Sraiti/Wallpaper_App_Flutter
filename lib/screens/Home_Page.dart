import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/DataManager.dart';
import 'package:flutter_app/models/ImageItem.dart';
import 'package:flutter_app/screens/ImagesViewer.dart';
import 'package:flutter_app/screens/MasterScreen.dart';
import 'package:flutter_app/util/DarkThemeProvider.dart';
import 'package:flutter_app/util/Styles.dart';
import 'package:flutter_app/util/constant.dart';
import 'package:flutter_app/util/util.dart';
import 'package:flutter_app/util/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Favorites_Page.dart';

class HomePage extends StatefulWidget {
  static final String id = "homepage";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DataManager alldata = DataManager.getInstance();

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

  Widget buildBottomSheet(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
          stops: [
            0.2,
            1,
          ],
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MasterPage(),
                    ),
                  );
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

  Future<bool> _onBackPressed(BuildContext context) {
    return showModalBottomSheet(context: context, builder: buildBottomSheet);
  }

  @override
  Widget build(BuildContext context) {
//    nativeAd = NativeAd();
//    _loadInter();
    return ChangeNotifierProvider(
      child: Consumer<DarkThemeProvider>(builder: (BuildContext context,
          value,
          Widget child,) {
        return WillPopScope(
          onWillPop: () => _onBackPressed(context),
          child: MaterialApp(
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            home: Scaffold(
              drawer: Drawer(
                // Add a ListView to the drawer. This ensures the user can scroll
                // through the options in the drawer if there isn't enough vertical
                // space to fit everything.
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 20,
                          sigmaY: 20,
                        ),
                        child: Image.asset('assets/images/logo.png'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        trailing: Icon(
                          Icons.contact_mail,
                          color: Colors.pink,
                        ),
                        title: Text(
                          'Contact Us',
                          style: TextStyle(color: Colors.pink),
                        ),
                        subtitle: Text(
                          'Send Email To Support',
                        ),
                        onTap: () {
                          launchURL(
                              'mailto:khalid@gmail.com?subject=what is your subject&body=');
                        },
                      ),
                    ),
                    Card(
                      child: ListTile(
                        trailing: Image.asset(
                          'assets/images/insta.png',
                          width: 25,
                          height: 30,
                        ),
                        title: Text(
                          'Instagram',
                          style: TextStyle(color: Colors.pink.shade600),
                        ),
                        subtitle: Text(
                          'Flowing Us In Instagram',
                        ),
                        onTap: () {
                          launchURL('http://instagram.com/Morning_friends');
                        },
                      ),
                    ),
                    Card(
                      child: ListTile(
                        trailing: Icon(
                          Icons.more,
                          color: Colors.indigo,
                        ),
                        title: Text(
                          'More Apps',
                          style: TextStyle(color: Colors.indigo),
                        ),
                        subtitle: Text(
                          'Find More Apps',
                        ),
                        onTap: () {},
                      ),
                    ),
                    Card(
                      child: ListTile(
                        trailing: Icon(
                          Icons.share,
                          color: Colors.orange,
                        ),
                        title: Text(
                          'Share App',
                          style: TextStyle(color: Colors.orange),
                        ),
                        subtitle: Text(
                          'Share App With Your Friends',
                        ),
                        onTap: () {},
                      ),
                    ),
                    Card(
                      child: ListTile(
                        trailing: Icon(
                          Icons.insert_drive_file,
                          color: Colors.green,
                        ),
                        title: Text(
                          'Privacy Policy',
                          style: TextStyle(color: Colors.green),
                        ),
                        subtitle: Text(
                          'Read The Privacy Ploicy',
                        ),
                        onTap: () {},
                      ),
                    ),
                    Card(
                      child: ListTile(
                        trailing: Icon(
                          Icons.stars,
                          color: Colors.purple,
                        ),
                        title: Text(
                          'Rate Us',
                          style: TextStyle(color: Colors.purple),
                        ),
                        subtitle: Text(
                          'Rate This App In Play Store',
                        ),
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
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
                    facebookadBanner(),
                    ShowMore(
                      text: alldata.clickedCategory.name,
                      haveButton: false,
                    ),
                    Latest(
                      dataManger: alldata,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
      create: (BuildContext context) {
        return themeChangeProvider;
      },
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
                                        builder: (context) =>
                                            ImagesViewer(
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
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 2,
                  height: 90,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: Hero(
                      tag: dataManger.allImages[index].urlImage +
                          dataManger.allImages[index].CatName,
                      child: CachedNetworkImage(
                        imageUrl:
                        constant.SERVER_IMAGE_UPFOLDER_CATEGORY +
                            dataManger.clickedCategory.name
                                .replaceAll(' ', '%20') +
                            '/' +
                            dataManger.allImages[index].urlImage,
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
                        placeholder: (context, url) =>
                            Image.asset(
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
