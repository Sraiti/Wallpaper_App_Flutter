import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/dbManager.dart';
import 'package:flutter_app/models/ImageItem.dart';
import 'package:flutter_app/util/DarkThemeProvider.dart';
import 'package:flutter_app/util/constant.dart';
import 'package:flutter_app/util/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';

class ImagesViewer extends StatefulWidget {
  static const String id = "ImagesViewer";

  ImagesViewer({this.imageID, this.images});

  bool isFav = false;
  int imageID = 0;

  List<ImageItem> images;

  @override
  _ImagesViewerState createState() => _ImagesViewerState();
}

class _ImagesViewerState extends State<ImagesViewer> {
  ImageDBController imageDBController = new ImageDBController();
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    widget.images[widget.imageID].isfav == 1
        ? widget.isFav = true
        : widget.isFav = false;
  }

  Widget buildBottomSheet(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.blueAccent,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: NativeAd(),
          ),
          Text(
            "Share Image with Your Friends",
            style: TextStyle(
              fontSize: 16.0,
              fontFamily: 'good2',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton.icon(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                label: Text(
                  'Share',
                ),
                icon: Icon(Icons.share),
                color: Colors.black12,
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<bool> _onsharePressed(BuildContext context) {
    return showModalBottomSheet(context: context, builder: buildBottomSheet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView.builder(
            controller: PageController(
              initialPage: widget.imageID,
            ),
            itemCount: widget.images.length,
            onPageChanged: (newValue) {
              setState(
                () {
                  constant.countNative++;
                  widget.imageID = newValue;
                  widget.images[widget.imageID].isfav == 1
                      ? widget.isFav = true
                      : widget.isFav = false;
                },
              );
            },
            itemBuilder: (BuildContext context, int itemIndex) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 0.0),
                child: Hero(
                  tag: widget.images[itemIndex].imageUrl +
                      widget.images[itemIndex].catName,
                  child: CachedNetworkImage(
                    width: MediaQuery.of(context).size.width,
                    height: double.infinity,
                    imageUrl: constant.SERVER_IMAGE_UPFOLDER_CATEGORY +
                        widget.images[itemIndex].catName
                            .replaceAll(' ', '%20') +
                        '/' +
                        widget.images[itemIndex].imageUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Image.asset(
                      'assets/images/loading.png',
                      fit: BoxFit.cover,
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 28,
            left: 8,
            child: FloatingActionButton(
              tooltip: 'Close',
              child: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () {
                print("close");
                Navigator.pop(context);
              },
              heroTag: 'close',
              mini: true,
              backgroundColor: Colors.black54,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Container(
                      width: double.infinity,
                      // height: MediaQuery.of(context).size.height - 200,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                      ),

                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              widget.isFav
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.favorite,
                                        size: 30.0,
                                      ),
                                      color: Colors.pink,
                                      onPressed: () {
                                        Fluttertoast.showToast(
                                            msg: "Deleted From Favorites",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                        setState(
                                          () {
                                            widget.images[widget.imageID]
                                                .isfav = 0;

                                            widget.isFav = false;
                                            imageDBController.deletefav(
                                              widget.images[widget.imageID],
                                            );
                                          },
                                        );
                                      },
                                    )
                                  : IconButton(
                                      icon: Icon(Icons.favorite_border),
                                      color: Colors.pink,
                                      onPressed: () {
                                        Fluttertoast.showToast(
                                            msg: "Added To Favorites",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                        setState(
                                          () {
                                            widget.isFav = true;
                                            widget.images[widget.imageID]
                                                .isfav = 1;
                                            imageDBController.addToFav(
                                              widget.images[widget.imageID],
                                            );
                                          },
                                        );
                                      },
                                    ),
                              IconButton(
                                icon: Icon(
                                  Icons.file_download,
                                  size: 25.0,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  Fluttertoast.showToast(
                                      msg: "Downloading... ",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  setState(() async {
                                    await ImageDownloader.downloadImage(
                                      constant.SERVER_IMAGE_UPFOLDER_CATEGORY +
                                          widget.images[widget.imageID].catName
                                              .replaceAll(' ', '%20') +
                                          '/' +
                                          widget
                                              .images[widget.imageID].imageUrl,
                                      destination: AndroidDestinationType
                                          .directoryDownloads
                                        ..subDirectory("custom/sample.gif"),
                                    );
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16.0,
                    top: 0.0,
                    child: FloatingActionButton(
                        tooltip: 'Set as Wallpaper',
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.share,
                          color: Colors.deepPurple,
                        ),
                        onPressed: () async {
                          await _onsharePressed(context);
                          // print(res);
                          var request = await HttpClient().getUrl(
                            Uri.parse(
                              constant.SERVER_IMAGE_UPFOLDER_CATEGORY +
                                  widget.images[widget.imageID].catName
                                      .replaceAll(' ', '%20') +
                                  '/' +
                                  widget.images[widget.imageID].imageUrl,
                            ),
                          );
                          var response = await request.close();
                          Uint8List bytes =
                              await consolidateHttpClientResponseBytes(
                                  response);
                          await Share.file(
                              'ESYS AMLOG', 'amlog.gif', bytes, 'image/gif',
                              text: 'More Photos => ' +
                                  constant.prefixstore +
                                  constant.package);
                          print("done");
                        }),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
