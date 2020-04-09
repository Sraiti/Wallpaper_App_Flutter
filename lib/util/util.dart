import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
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
    barrierDismissible: false,
    builder: (context) =>
        Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.all(5),
            child: TextLiquidFill(
              text: message,
              waveDuration: Duration(seconds: 10),
              waveColor: Colors.blueAccent,
              boxBackgroundColor: Colors.white,
              textStyle: TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.w800,
                fontFamily: "good2",
              ),
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

SnackBar snackBar() {
  String snaktext;
  IconData snakicon;

  snackBar(String snaktext, IconData snakicon) {
    snaktext;
    snakicon;
  }

  ;
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
