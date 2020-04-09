import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/DataManager.dart';
import 'package:flutter_app/models/ImageItem.dart';
import 'package:flutter_app/models/cat.dart';
import 'package:flutter_app/util/DarkThemeProvider.dart';
import 'package:flutter_app/util/Styles.dart';
import 'package:flutter_app/util/constant.dart';
import 'package:flutter_app/util/util.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'Home_Page.dart';

String title_string = "Categories";

class Destination {
  const Destination(this.title, this.icon, this.color);

  final String title;
  final IconData icon;
  final Color color;
}

const List<Destination> allDestinations = <Destination>[
  Destination('Categories', Icons.category, Colors.blueAccent),
  Destination('Settings', Icons.settings, Colors.blueAccent),
];

class RootPage extends StatefulWidget {
  RootPage({this.destination});
  final Destination destination;

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  DataManager allData = DataManager.getInstance();

  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: allData.getAllFavImages(),
        builder: (context, snapshot) {
          List<ImageItem> dbImages = snapshot.data;
          return Scaffold(
            backgroundColor: widget.destination.color.withAlpha(50),
            body: SafeArea(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        itemCount: allData.allCategories.length,
                        itemBuilder: (context, position) {
                          return CategoryCard(
                              categoryName:
                              allData.allCategories[position].name,
                              imageUrl: constant.CATEGORY_IMAGE +
                                  allData.allCategories[position].imageUrl,
                              function: () async {
                                allData.clickedCategory = CatItem(
                                  name: allData.allCategories[position].name,
                                  imageUrl:
                                  allData.allCategories[position].imageUrl,
                                  id: allData.allCategories[position].id,
                                );

                                Response response = await get(
                                  constant.CATEGORY_ITEM_URL +
                                      allData.allCategories[position].id
                                          .toString(),
                                );

                                Map _data = jsonDecode(response.body);

                                if (response.statusCode == 200) {
                                  for (var imageItem in _data['HDwallpaper']) {
                                    ImageItem image = new ImageItem();
                                    image.urlImage =
                                        imageItem['images'].toString();
                                    image.CatName =
                                        imageItem['cat_name'].toString();
                                    image.isfav = 0;
                                    ImageItem isFavouriteCheck =
                                    dbImages.firstWhere(
                                            (user) =>
                                        user.urlImage + user.CatName ==
                                            image.urlImage + user.CatName,
                                        orElse: () => null);
                                    (isFavouriteCheck == null)
                                        ? image.isfav = 0
                                        : image.isfav = 1;

                                    allData.allImages.add(image);
                                  }
                                  print("Clicked 1");
                                  Navigator.pop(context);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomePage(),
                                    ),
                                  );
                                }
                              });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({this.imageUrl, this.categoryName, this.function});

  final String imageUrl;
  final String categoryName;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) =>
                      Icon(
                        Icons.error,
                      ),
                  placeholder: (context, url) =>
                      Image.asset(
                    'assets/images/loading_book.gif',
                        fit: BoxFit.fill,
                      ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(5.0),
                child: Text(
                  categoryName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key, this.destination}) : super(key: key);

  final Destination destination;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      backgroundColor: widget.destination.color.withAlpha(50),
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Switch(
                    activeColor: Colors.blueAccent,
                    value: themeChange.darkTheme,
                    onChanged: (newValue) {
                      setState(
                            () {
                          themeChange.darkTheme = newValue;
                        },
                      );
                    },
                  ),
                  Text("Dark Mode"),
                ],
              ),
              FacebookNativeAd(
                placementId: "756894781441261_759233337874072",
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
              Container(
                color: Colors.blueAccent.shade100,
                child: ListTile(
                  title: Text(
                    "About The App",
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: "good2",
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    FacebookAudienceNetwork.init(
      testingId: "2f289099-1391-45ba-b87d-4feb3a89b5d4",
    );
  }
}

class MasterPage extends StatefulWidget {
  static final String id = "MasterPage";

  @override
  _MasterPageState createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  int _currentIndex = 0;

  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  bool _isInterstitialAdLoaded = false;
  bool _isRewardedAdLoaded = false;
  bool _isRewardedVideoComplete = false;
  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    FacebookAudienceNetwork.init(
      testingId: "2f289099-1391-45ba-b87d-4feb3a89b5d4",
    );
    _loadInterstitialAd();
  }

  _showInterstitialAd() {
    if (_isInterstitialAdLoaded == true)
      FacebookInterstitialAd.showInterstitialAd();
    else
      print("Interstial Ad not yet loaded!");
  }

  void _loadInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: constant.Interstitial,
      listener: (result, value) {
        print("Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED)
          _isInterstitialAdLoaded = true;

        /// Once an Interstitial Ad has been dismissed and becomes invalidated,
        /// load a fresh Ad by calling this function.
        if (result == InterstitialAdResult.DISMISSED &&
            value["invalidated"] == true) {
          _isInterstitialAdLoaded = false;
          _loadInterstitialAd();
        }
      },
    );
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
  }

  void bottomTapped(int index) {
    setState(() {
      _currentIndex = index;
      (_currentIndex == 0)
          ? title_string = "Categories"
          : title_string = "Settings";
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void pageChanged(int index) {
    setState(() {
      _showInterstitialAd();
      _currentIndex = index;
      (_currentIndex == 0)
          ? title_string = "Categories"
          : title_string = "Settings";
    });
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      child: Consumer<DarkThemeProvider>(builder: (BuildContext context,
          value,
          Widget child,) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
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
            appBar: AppBar(
              title: Text(title_string),
            ),
            body: PageView(
              controller: pageController,
              onPageChanged: (index) {
                pageChanged(index);
              },
              children: <Widget>[
                RootPage(destination: allDestinations[0]),
                SettingsPage(destination: allDestinations[1])
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (int index) {
                setState(() {
                  _currentIndex = index;
                  bottomTapped(index);
                });
              },
              items: allDestinations.map((Destination destination) {
                return BottomNavigationBarItem(
                    icon: Icon(
                      destination.icon,
                      color: destination.color,
                      size: 25.0,
                    ),
                    backgroundColor: destination.color,
                    title: Text(
                      destination.title,
                      style: TextStyle(color: destination.color),
                    ));
              }).toList(),
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
