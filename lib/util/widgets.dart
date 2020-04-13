import 'dart:ui';

import 'package:esys_flutter_share/esys_flutter_share.dart';
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
        color: Colors.black12,
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
                fontSize: 16.0,
                wordSpacing: 2.0,
                fontFamily: 'good2',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          haveButton
              ? FlatButton(
                  color: Colors.black26,
                  child: Text(
                    'Show all favorites',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 10.0,
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

Widget getNativeFb() {
  return FacebookNativeAd(
    placementId: constant.BannerNative,
    adType: NativeAdType.NATIVE_AD,
    bannerAdSize: NativeBannerAdSize.HEIGHT_120,
    width: double.infinity,
    backgroundColor: Colors.deepPurple,
    titleColor: Colors.white,
    descriptionColor: Colors.white,
    buttonColor: Colors.blue,
    buttonTitleColor: Colors.white,
    buttonBorderColor: Colors.white,
    listener: (result, value) {
      if (result == NativeAdResult.LOADED) {}
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
              sigmaX: 20,
              sigmaY: 20,
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
            onTap: () {
              launchURL(
                  'https://play.google.com/store/apps/developer?id=Special+Ones+Group');
            },
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
            onTap: () {
              Share.text(
                  '分享应用',
                  '最好的照片花和爱 => ${constant.prefixstore + constant.package}',
                  'text/plain');
            },
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
            onTap: () {
              launchURL('http://dev3pro.com/index/privacy_policy.html');
            },
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
            onTap: () {
              launchURL(constant.prefixstore + constant.package);
            },
          ),
        ),
      ],
    );
  }
}
