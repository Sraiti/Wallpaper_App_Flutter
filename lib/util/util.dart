import 'dart:io';

import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/util/constant.dart';
import 'package:url_launcher/url_launcher.dart';

bool saveImage(Map<String, dynamic> map) {
  try {
    File(map['filePath'])
      ..createSync(recursive: true)
      ..writeAsBytesSync(map['bytes']);
    return true;
  } catch (e) {
    print('Saved image error: $e');
    return false;
  }
}

void showProgressDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    useRootNavigator: false,
    builder: (context) =>
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: CircularProgressIndicator(),
                ),
                Text(message),
              ],
            ),
          ),
        ),
  );
}

void launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

bool _isInterstitialAdLoaded = false;
bool _isRewardedAdLoaded = false;
bool _isRewardedVideoComplete = false;

void loadInterstitialAd() {
  FacebookInterstitialAd.loadInterstitialAd(
    placementId: constant.Interstitial,
    listener: (result, value) {
      print("Interstitial Ad: $result --> $value");
      if (result == InterstitialAdResult.LOADED) _isInterstitialAdLoaded = true;

      /// Once an Interstitial Ad has been dismissed and becomes invalidated,
      /// load a fresh Ad by calling this function.
      if (result == InterstitialAdResult.DISMISSED &&
          value["invalidated"] == true) {
        _isInterstitialAdLoaded = false;
        loadInterstitialAd();
      }
    },
  );
}

showInterstitialAd() {
  if (_isInterstitialAdLoaded == true)
    FacebookInterstitialAd.showInterstitialAd();
  else
    print("Interstial Ad not yet loaded!");
}
