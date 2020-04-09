import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/Home_Page.dart';
import 'package:flutter_app/screens/ImagesViewer.dart';
import 'package:flutter_app/screens/MasterScreen.dart';
import 'package:flutter_app/screens/splash.dart';
import 'package:flutter_app/util/DarkThemeProvider.dart';
import 'package:flutter_app/util/Styles.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    FacebookAudienceNetwork.init(
      testingId: "f9505dcf-de56-4d78-bb83-2a452e02861f",
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context,
            value,
            Widget child,) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            initialRoute: Splash.id,
            routes: {
              Splash.id: (context) => Splash(),
              HomePage.id: (context) => HomePage(),
              ImagesViewer.id: (context) => ImagesViewer(),
              MasterPage.id: (context) => MasterPage(),
            },
          );
        },
      ),
      create: (BuildContext context) {
        return themeChangeProvider;
      },
    );
  }
}
