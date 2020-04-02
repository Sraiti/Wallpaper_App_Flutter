import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/DataManager.dart';
import 'package:flutter_app/models/cat.dart';
import 'package:flutter_app/models/itemImage.dart';
import 'package:flutter_app/util/ConstantStyles.dart';
import 'package:flutter_app/util/constant.dart';
import 'package:flutter_app/util/util.dart';
import 'package:http/http.dart';

import 'home_page.dart';

class Destination {
  const Destination(this.title, this.icon, this.color);

  final String title;
  final IconData icon;
  final Color color;
}

const List<Destination> allDestinations = <Destination>[
  Destination('Categories', Icons.category, Colors.blue),
  Destination('Settings', Icons.settings, Colors.blueAccent),
];

class RootPage extends StatelessWidget {
  RootPage({Key key, this.destination}) : super(key: key);
  final Destination destination;
  DataManager alldata = DataManager.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(destination.title),
        backgroundColor: destination.color,
      ),
      backgroundColor: destination.color.withAlpha(50),
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: alldata.allcats.length,
                  itemBuilder: (context, position) {
                    return CategoryCard(
                        categoryName: alldata.allcats[position].name,
                        imageUrl: constant.CATEGORY_IMAGE +
                            alldata.allcats[position].imageUrl,
                        function: () async {
                          print("Clicked");
                          alldata.ClickedCat = CatItem(
                            name: alldata.allcats[position].name,
                            imageUrl: alldata.allcats[position].imageUrl,
                            id: alldata.allcats[position].id,
                          );
                          print("Clicked cat name:" + alldata.ClickedCat.name);

                          Response response = await get(
                            constant.CATEGORY_ITEM_URL +
                                alldata.allcats[position].id.toString(),
                          );
                          print(constant.CATEGORY_ITEM_URL +
                              alldata.allcats[position].id.toString());
                          print(response.statusCode);
                          Map _data = jsonDecode(response.body);

                          print(_data.isNotEmpty.toString());
                          if (response.statusCode == 200) {
                            try {
                              for (var imageItem in _data['HDwallpaper']) {
                                itemImage image = new itemImage();
                                image.urlImage = imageItem['images'].toString();
                                print(image.urlImage);
                                image.isfav = 0;
                                image.CatName =
                                    imageItem['cat_name'].toString();
                                alldata.allImage.add(image);
                              }
                            } catch (e) {
                              Navigator.pop(context);
                            }
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => homepage(),
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
        showProgressDialog(context, "Fetching Images");
        function();
      },
      child: Card(
        color: Colors.grey.shade400,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Container(
          child: Column(
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Icon(Icons.error),
                placeholder: (context, url) => Image.asset(
                    'assets/images/loading_book.gif',
                    fit: BoxFit.fill),
              ),
              Container(
                width: double.infinity,
                color: Colors.grey.shade400,
                padding: EdgeInsets.all(5.0),
                child: Text(
                  categoryName,
                  style: kCategoryName,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextPage extends StatefulWidget {
  const TextPage({Key key, this.destination}) : super(key: key);

  final Destination destination;

  @override
  _TextPageState createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.destination.title),
        backgroundColor: widget.destination.color,
      ),
      backgroundColor: widget.destination.color.withAlpha(50),
      body: Container(
        child: Text("Text"),
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

  void bottomTapped(int index) {
    setState(() {
      _currentIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void pageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          pageChanged(index);
        },
        children: <Widget>[
          RootPage(destination: allDestinations[0]),
          TextPage(destination: allDestinations[1])
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
              icon: Icon(destination.icon),
              backgroundColor: destination.color,
              title: Text(destination.title));
        }).toList(),
      ),
    );
  }
}
