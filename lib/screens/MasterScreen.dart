import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/DataManager.dart';
import 'package:flutter_app/models/ImageItem.dart';
import 'package:flutter_app/models/cat.dart';
import 'package:flutter_app/util/DarkThemeProvider.dart';
import 'package:flutter_app/util/constant.dart';
import 'package:flutter_app/util/util.dart';
import 'package:flutter_app/util/widgets.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Home_Page.dart';

String title_string = "Categories";
DataManager allData = DataManager.getInstance();
String errorText = " ";

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
                Navigator.pop(context, true);
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

class _RootPageState extends State<RootPage> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        backgroundColor: widget.destination.color.withAlpha(50),
        body: FutureBuilder(
            future: allData.getAllFavImages(),
            builder: (context, snapshot) {
              List<ImageItem> dbImages = snapshot.data;
              return (allData.allCategories.isNotEmpty)
                  ? SafeArea(
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
                                          allData
                                              .allCategories[position].imageUrl,
                                      function: () async {
                                        allData.deleteAllImages();
                                        allData.clickedCategory = CatItem(
                                          name: allData
                                              .allCategories[position].name,
                                          imageUrl: allData
                                              .allCategories[position].imageUrl,
                                          id: allData
                                              .allCategories[position].id,
                                        );

                                        Response response = await get(
                                          constant.CATEGORY_ITEM_URL +
                                              allData.allCategories[position].id
                                                  .toString(),
                                        );

                                        Map _data = jsonDecode(response.body);

                                        if (response.statusCode == 200) {
                                          for (var imageItem
                                              in _data['HDwallpaper']) {
                                            ImageItem image = new ImageItem();
                                            image.urlImage =
                                                imageItem['images'].toString();
                                            image.CatName =
                                                imageItem['cat_name']
                                                    .toString();
                                            image.isfav = 0;
                                            ImageItem isFavouriteCheck =
                                                dbImages.firstWhere(
                                                    (user) =>
                                                        user.urlImage +
                                                            user.CatName ==
                                                        image.urlImage +
                                                            user.CatName,
                                                    orElse: () => null);
                                            (isFavouriteCheck == null)
                                                ? image.isfav = 0
                                                : image.isfav = 1;

                                            allData.allImages.add(image);
                                          }
                                          //Navigator.pop(context);

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
                    )
                  : Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Please Check Your Connection",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FlatButton(
                              color: Colors.blueAccent,
                              onPressed: () {
                                setState(
                                  () {
                                    getCategoriesData();
                                    errorText = "Please Try again;";
                                  },
                                );
                              },
                              child: Container(
                                child: Text("Try Again"),
                              ),
                            ),
                          ),
                          Text(errorText),
                        ],
                      ),
                    );
            }),
      ),
    );
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
        showProgressDialog(context, "Downloading ...");
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
                  errorWidget: (context, url, error) => Icon(
                    Icons.error,
                  ),
                  placeholder: (context, url) => Image.asset(
                    'assets/images/loading_book.gif',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                //padding: EdgeInsets.all(5.0),
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
              NativeAd(),
              Container(
                color: Colors.blueAccent.shade100,
                child: GestureDetector(
                  onTap: () {
                    launchURL(constant.aboutUrl);
                  },
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
              ),
            ],
          ),
        ],
      ),
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
      showInterstitialAd();
      _currentIndex = index;
      (_currentIndex == 0)
          ? title_string = "Categories"
          : title_string = "Settings";
    });
  }

  PageController pageController = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: MyDrawer(),
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
    );
  }
}
