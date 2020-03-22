import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/cat.dart';
import 'package:flutter_app/models/image.dart';
import 'package:flutter_app/models/itemImage.dart';
import 'package:flutter_app/screens/home_page.dart';
import 'package:flutter_app/util/constant.dart';
import 'package:flutter_app/util/sqlite.dart';
import 'package:http/http.dart';

class splash extends StatelessWidget {
  var alldata = data.getInstance();
  static final String id = "splash";

  var dbhelper = DBHelper();

  Future<void> getData() async {
    Response response = await get(constant.LATEST_URL);
    Map _data = jsonDecode(response.body);
    Response responseCat = await get(constant.CATEGORY_URL);
    Map _categorys = jsonDecode(responseCat.body);

    for (var catJson in _categorys['HDwallpaper']) {
      catItem cat = new catItem();
      cat.id = 0;
      cat.name = catJson['category_name'].toString().replaceAll(' ', '%20');
      cat.imageUrl = catJson['category_image'].toString();
      print(cat.name);
      alldata.allcats.add(cat);
    }
    for (var imageItem in _data['HDwallpaper']) {
      itemImage image = new itemImage();
      image.urlImage = imageItem['image'].toString();
      image.isfav = 0;
      image.CatName = imageItem['category_name'].toString();
      alldata.allImage.add(image);
    }
  }

  /* Future<void> startactivity() async {
    print('not yet');
    Response response = await get(constant.LATEST_URL);
    Map _data = jsonDecode(response.body);
    print('finish');

    for (var word in _data['HDwallpaper']) {
      alldata.allImage.add(word['image'].toString());
    }

    return runApp(homepage());
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            return homepage();
          else
            return splashBody();
        },
      ),
    );
  }

  void navigate(context) async {
    await Future.delayed(
        const Duration(seconds: 8),
        () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => homepage())));
  }
}

class splashBody extends StatelessWidget {
  const splashBody({
    Key key,
  }) : super(key: key);

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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: FadeInImage(
                    image: AssetImage(
                      'assets/loading.png',
                    ),
                    fit: BoxFit.cover,
                    placeholder: AssetImage('assets/images/loading.png'),
                  ),
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
