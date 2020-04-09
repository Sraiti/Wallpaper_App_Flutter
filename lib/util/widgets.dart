import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/util/constant.dart';

class ShowMore extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool haveButton;

  ShowMore({@required this.text, @required this.haveButton, this.onTap});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.lightBlue,
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
                fontSize: 20.0,
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
                    'Favorites',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15.0,
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

class facebookadBanner extends StatefulWidget {
  @override
  _facebookadState createState() => _facebookadState();
}

class _facebookadState extends State<facebookadBanner> {
  Widget _currentAd = Container(
    width: 10.0,
    height: 100.0,
    child: Text('cccc'),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      print("initstate");
    });
  }

  @override
  Widget build(BuildContext context) {
    FacebookBannerAd();
    return Column(
      children: <Widget>[
        FacebookBannerAd(
          placementId: constant.banner,
          bannerSize: BannerSize.STANDARD,
          listener: (result, value) {
            switch (result) {
              case BannerAdResult.ERROR:
                print("Error: $value");
                break;
              case BannerAdResult.LOADED:
                print("Loaded: $value");
                setState(() {
                  print('setstate');
                });
                break;
              case BannerAdResult.CLICKED:
                print("Clicked: $value");
                break;
              case BannerAdResult.LOGGING_IMPRESSION:
                print("Logging Impression: $value");
                break;
            }
          },
        )
      ],
    );
  }
}

class NativeAd extends StatefulWidget {
  @override
  _NativeAdState createState() => _NativeAdState();
}

class _NativeAdState extends State<NativeAd> {
  Widget _nativeAd = Image.asset(
    "assets/images/loading_book.gif",
    fit: BoxFit.cover,
    alignment: Alignment.center,
    width: double.infinity,
    repeat: ImageRepeat.noRepeat,
  );

  FacebookNativeAd FbNative;

  FacebookNativeAd _loadad() {
    FacebookNativeAd native = FacebookNativeAd(
      placementId: constant.Native,
      adType: NativeAdType.NATIVE_AD,
      width: double.infinity,
      height: 300,
      backgroundColor: Colors.blue,
      titleColor: Colors.white,
      descriptionColor: Colors.white,
      buttonColor: Colors.deepPurple,
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

class NativeBanner extends StatefulWidget {
  @override
  _NativeBannerState createState() => _NativeBannerState();
}

class _NativeBannerState extends State<NativeBanner> {
  Widget adsNativeBanner = Container(
    height: 0.0,
    width: 0.0,
  );

  @override
  Widget build(BuildContext context) {
    adsNativeBanner = FacebookNativeAd(
      placementId: constant.BannerNative,
      adType: NativeAdType.NATIVE_BANNER_AD,
      bannerAdSize: NativeBannerAdSize.HEIGHT_50,
      width: double.infinity,
      backgroundColor: Colors.blue,
      titleColor: Colors.white,
      descriptionColor: Colors.white,
      buttonColor: Colors.deepPurple,
      buttonTitleColor: Colors.white,
      buttonBorderColor: Colors.white,
      listener: (result, value) {
        // print("Native Ad: $result --> $value");

        switch (value) {
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
    );

    return adsNativeBanner;
  }
}

class snakbarWidget extends StatelessWidget {
  final String snaktext;
  final IconData snakicon;

  snakbarWidget({@required this.snaktext, @required this.snakicon});

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(snakicon),
          SizedBox(
            width: 12.0,
          ),
          Text(snaktext),
        ],
      ),
    );
  }
}

class ProgressWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _showDialog(context);
  }

  Widget _showDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: new Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
