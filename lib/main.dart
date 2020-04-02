import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/dbManager.dart';
import 'package:flutter_app/screens/MasterScreen.dart';
import 'package:flutter_app/screens/home_page.dart';
import 'package:flutter_app/screens/splash.dart';
import 'package:flutter_app/screens/wallpaper.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    FacebookAudienceNetwork.init(
      testingId: "7a5e22d0-9161-43dc-bf61-ac9af0c6b11f",
    );
    OneSignal.shared.init("93a9b681-97bd-4fa8-af4c-c0f152cfeffa");
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => allImage(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        initialRoute: splash.id,
        routes: {
          splash.id: (context) => splash(),
          homepage.id: (context) => homepage(),
          WallpaperPage.id: (context) => WallpaperPage(),
          MasterPage.id: (context) => MasterPage(),
        },
      ),
    );
  }
}
