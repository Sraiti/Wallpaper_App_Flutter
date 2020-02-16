import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/util/constant.dart';
import 'package:toast/toast.dart';

class ShowMore extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool haveButton;

  ShowMore({@required this.text, @required this.haveButton, this.onTap});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.2, 1],
            colors: [Colors.orange, Colors.pink]),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 22.0,
                fontFamily: 'Caveat',
              ),
            ),
          ),
          haveButton
              ? FlatButton(
                  color: Colors.black12,
                  child: Text(
                    'See all Favorites',
                    style: TextStyle(
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

  void _loadfbinter() {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      print("initstate");
      FacebookAudienceNetwork.init(
        testingId: "e6d67e88-aced-4e6f-b392-79d9d6e9b676",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    FacebookBannerAd();
    return Column(
      children: <Widget>[
        FacebookBannerAd(
          placementId: "YOUR_PLACEMENT_ID",
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

class NativeAd extends StatelessWidget {
  FacebookNativeAd _nativeAd;

  FacebookNativeAd _loadad() {
    print("loadad");
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
      },
    );

    return native;
  }

  @override
  Widget build(BuildContext context) {
    _nativeAd = _loadad();

    return _nativeAd;
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
      placementId: "YOUR_PLACEMENT_ID",
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
