import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/DataManager.dart';
import 'package:flutter_app/models/cat.dart';
import 'package:flutter_app/screens/MasterScreen.dart';
import 'package:flutter_app/util/constant.dart';
import 'package:http/http.dart';
import 'package:splashscreen/splashscreen.dart';

class Splash extends StatefulWidget {
  static final String id = "splash";

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void getCategoriesData() async {
    DataManager alldata = DataManager.getInstance();
    Response responseCat = await get(constant.CATEGORY_URL);
    Map _categories = jsonDecode(responseCat.body);

    for (var catJson in _categories['HDwallpaper']) {
      CatItem cat = new CatItem(
        id: int.parse(catJson['cid']),
        imageUrl: catJson['category_image'].toString(),
        name: catJson['category_name'].toString(),
      );

      if (!alldata.allCategories.contains(cat)) {
        alldata.allCategories.add(cat);
        print("Cat Added ${cat.name} " +
            alldata.allCategories.contains(cat).toString());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCategoriesData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SplashScreen(
          seconds: 5,
          navigateAfterSeconds: MasterPage(),
          title: Text(
            'Welcome In ${constant.nameApp}',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              wordSpacing: 5.0,
              fontSize: 30.0,
            ),
          ),
          image: Image.asset('assets/images/logo.png'),
          backgroundColor: Colors.white,
          styleTextUnderTheLoader: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 48.0,
          ),
          photoSize: 100.0,
          loaderColor: Colors.red,
          imageBackground: AssetImage('assets/images/splashimage.jpg'),
        ),
      ),
    );
  }
}

class SplashBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/splashimage.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Container(
                width: 100,
                height: 100,
                child: FadeInImage(
                  image: AssetImage(
                    'assets/images/logo.png',
                  ),
                  fit: BoxFit.cover,
                  placeholder: AssetImage('assets/images/loading.png'),
                ),
              ),
            ),
            Text(
              constant.nameApp,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Caveat',
                fontSize: 40.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
