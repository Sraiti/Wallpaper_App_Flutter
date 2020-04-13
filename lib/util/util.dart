import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/CatItem.dart';
import 'package:flutter_app/models/DataManager.dart';
import 'package:flutter_app/models/ImageItem.dart';
import 'package:flutter_app/util/constant.dart';
import 'package:http/http.dart';
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
    builder: (context) => Dialog(
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
  print("load Inter");
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
  print(_isInterstitialAdLoaded);
  if (_isInterstitialAdLoaded == true)
    FacebookInterstitialAd.showInterstitialAd();
  else
    print("Interstial Ad not yet loaded!");
}

void getCategoriesData() async {
  DataManager alldata = DataManager.getInstance();
  Response responseCat = await get(constant.CATEGORY_URL);
  var _categories = jsonDecode(responseCat.body);

  if (responseCat.statusCode == 200) {
    CategoriesGrabber c = CategoriesGrabber.fromJson(_categories);
    alldata.allCategories = c.categoriesList;
  }
}

Future<void> getImagesData(int position, List<ImageItem> imagesDb) async {
  DataManager allData = DataManager.getInstance();
  Response response = await get(
    constant.CATEGORY_ITEM_URL + allData.allCategories[position].cid.toString(),
  );
  var _data = jsonDecode(response.body);
  if (response.statusCode == 200) {
    ImagesGrabber images = ImagesGrabber.fromJson(_data, imagesDb);
    allData.allImages = images.imagesList;
  }
}
