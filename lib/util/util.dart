import 'dart:io';

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
    builder: (context) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(message),
              ),
            ],
          ),
        ),
      );
    },
  );
}

_launchURL(url) async {
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
