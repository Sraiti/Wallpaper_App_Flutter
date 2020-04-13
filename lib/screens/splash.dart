import 'package:flutter/material.dart';
import 'package:flutter_app/screens/MasterScreen.dart';
import 'package:flutter_app/util/constant.dart';
import 'package:flutter_app/util/util.dart';
import 'package:splashscreen/splashscreen.dart';

class Splash extends StatefulWidget {
  static final String id = "splash";

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    getCategoriesData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        image: Image.asset('assets/images/ic_launcher.png'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 48.0,
        ),
        photoSize: 100.0,
        loaderColor: Colors.red,
        imageBackground: AssetImage('assets/images/splashimage.jpg'),
      ),
    );
  }
}
