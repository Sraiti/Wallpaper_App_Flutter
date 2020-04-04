import 'package:flutter/material.dart';
import 'package:flutter_app/screens/MasterScreen.dart';
import 'package:flutter_app/screens/home_page.dart';
import 'package:flutter_app/screens/splash.dart';
import 'package:flutter_app/screens/wallpaper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
//    FacebookAudienceNetwork.init(
//      testingId: "7a5e22d0-9161-43dc-bf61-ac9af0c6b11f",
//    );
//    OneSignal.shared.init("93a9b681-97bd-4fa8-af4c-c0f152cfeffa");
//    OneSignal.shared
//        .setInFocusDisplayType(OSNotificationDisplayType.notification);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.red,
      ),
      initialRoute: splash.id,
      routes: {
        splash.id: (context) => splash(),
        homepage.id: (context) => homepage(),
        WallpaperPage.id: (context) => WallpaperPage(),
        MasterPage.id: (context) => MasterPage(),
      },
    );
  }
}
