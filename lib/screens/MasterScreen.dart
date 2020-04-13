import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/DataManager.dart';
import 'package:flutter_app/util/DarkThemeProvider.dart';
import 'package:flutter_app/util/constant.dart';
import 'package:flutter_app/util/util.dart';
import 'package:flutter_app/util/widgets.dart';
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
          child: getNativeFb(),
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
                                      name: allData
                                          .allCategories[position].categoryName,
                                      image: constant.CATEGORY_IMAGE +
                                          allData.allCategories[position]
                                              .categoryImage,
                                      function: () async {
                                        allData.deleteAllImages();

                                        ///Getting  the name of the clicked Category To use it in Home Page In the Url
                                        allData.clickedCategory =
                                            allData.allCategories[position];

                                        if (snapshot.hasData) {
                                          print("true");
                                          print(snapshot.data);
                                        } else {
                                          print("False");
                                        }
                                        await getImagesData(
                                            position, snapshot.data);

                                        ///Dismissing the Downloading Dialog
                                        Navigator.pop(context);

                                        ///Pushing new Page
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomePage(),
                                          ),
                                        );
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
//
//void Filter() async {
//  List<ImageItem> dbImages = await allData.getAllFavImages();
//  for (ImageItem item in allData.allImages) {
//    ImageItem isFavouriteCheck = dbImages.firstWhere(
//        (image) =>
//            image.imageUrl + image.catName == image.imageUrl + image.catName,
//        orElse: () => null);
//    (isFavouriteCheck == null) ? imageItem.isfav = 0 : imageItem.isfav = 1;
//  }
//
//  for (ImageItem i in dbImages) {
//    print("dbImages ${i.imageUrl} is fav ${i.isfav}");
//  }
//}

class CategoryCard extends StatelessWidget {
  const CategoryCard({this.image, this.name, this.function});

  final String image;
  final String name;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showProgressDialog(context, "Downloading ...");
        await function();
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          height: 100,
          child: Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30.0,
                      fontFamily: "good2",
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                    ),
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
              getNativeFb(),
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
                        fontSize: 20,
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
    loadInterstitialAd();
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
      if (constant.countInter % 3 == 0) {
        showInterstitialAd();
      }
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
