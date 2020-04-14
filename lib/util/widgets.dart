import 'dart:ui';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/util/constant.dart';
import 'package:flutter_app/util/util.dart';

class ShowMore extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool haveButton;

  ShowMore({@required this.text, @required this.haveButton, this.onTap});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black54,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          haveButton
              ? IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                wordSpacing: 2.0,
                fontFamily: 'good2',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          haveButton
              ? FlatButton(
                  color: Colors.white70,
                  child: Text(
                    'Show All',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0,
                      fontFamily: 'good2',
                    ),
                  ),
                  onPressed: onTap,
                )
              : Container(),
        ],
      ),
    );
  }
}

Widget getBannerFB() {
  return Container(
    alignment: Alignment(0.5, 1),
    child: FacebookBannerAd(
      placementId: "YOUR_PLACEMENT_ID",
      bannerSize: BannerSize.STANDARD,
      listener: (result, value) {
        switch (result) {
          case BannerAdResult.ERROR:
            print("Error: $value");
            break;
          case BannerAdResult.LOADED:
            print("Loaded: $value");
            break;
          case BannerAdResult.CLICKED:
            print("Clicked: $value");
            break;
          case BannerAdResult.LOGGING_IMPRESSION:
            print("Logging Impression: $value");
            break;
        }
      },
    ),
  );
}

Widget getNativeBannerFB() {
  return FacebookNativeAd(
    placementId: constant.BannerNative,
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
  );
}

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10,
              sigmaY: 10,
            ),
            child: Image.asset('assets/images/ic_launcher.png'),
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
    );
  }
}

class NativeAd extends StatefulWidget {
  @override
  _NativeAdState createState() => _NativeAdState();
}

class _NativeAdState extends State<NativeAd> {
  Widget _nativeAd = Container(
    alignment: Alignment.center,
    child: CircularProgressIndicator(
      backgroundColor: Colors.white70,
    ),
  );

  FacebookNativeAd FbNative;

  FacebookNativeAd _loadad() {
    FacebookNativeAd native = FacebookNativeAd(
      placementId: constant.Native,
      adType: NativeAdType.NATIVE_AD,
      width: double.infinity,
      height: 300,
      backgroundColor: Colors.deepPurple,
      titleColor: Colors.white,
      descriptionColor: Colors.white,
      buttonColor: Colors.blue,
      buttonTitleColor: Colors.white,
      buttonBorderColor: Colors.white,
      listener: (result, value) {
        print("Native Ad: $result --> $value");

        switch (result) {
          case NativeAdResult.ERROR:
            // TODO: Handle this case.
            setState(() {
              _nativeAd = Center(
                child: Text(
                  "No ad To Show",
                  style: TextStyle(
                    fontSize: 17.0,
                  ),
                ),
              );
            });

            break;
          case NativeAdResult.LOADED:
            // TODO: Handle this case.

            break;
          case NativeAdResult.CLICKED:
            // TODO: Handle this case.
            break;
          case NativeAdResult.LOGGING_IMPRESSION:
            setState(() {
              _nativeAd = Text("loading");
            });
            break;
          case NativeAdResult.MEDIA_DOWNLOADED:
            print("==>NativeAdResult.loading");
            break;
        }
      },
    );

    return native;
  }

  @override
  Widget build(BuildContext context) {
    //_nativeAd = ;

    return Stack(
      children: <Widget>[_nativeAd, _loadad()],
    );
  }
}
