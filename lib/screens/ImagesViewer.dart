import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/DataManager.dart';
import 'package:flutter_app/util/constant.dart';
import 'package:flutter_app/util/widgets.dart';
import 'package:image_downloader/image_downloader.dart';

class ImagesViewer extends StatefulWidget {
  @override
  _ImagesViewerState createState() => _ImagesViewerState();
}

class _ImagesViewerState extends State<ImagesViewer> {
  static const String id = "ImagesViewer";
  var dataManager = DataManager.getInstance();

  Widget buildBottomSheet(BuildContext) {
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
                  Navigator.pop(BuildContext, true);
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

  Future<bool> _onsharePressed(context) {
    return showModalBottomSheet(context: context, builder: buildBottomSheet);
  }

  @override
  Widget build(BuildContext context) {
    int pageViewerIndex = 0;
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            PageView.builder(
              itemCount: dataManager.allImage.length,
              onPageChanged: (newValue) {
                setState(() {
                  pageViewerIndex = newValue;
                });
              },
              itemBuilder: (BuildContext context, int itemIndex) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 0.0),
                  child: CachedNetworkImage(
                    width: MediaQuery.of(context).size.width,
                    height: double.infinity,
                    imageUrl: constant.SERVER_IMAGE_UPFOLDER_CATEGORY +
                        dataManager.allImage[itemIndex].CatName
                            .replaceAll(' ', '%20') +
                        '/' +
                        dataManager.allImage[itemIndex].urlImage,
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
                backgroundColor: Colors.white30,
              ),
            ),
            Column(
              children: <Widget>[
                Expanded(
                  child: Container(

                      // width: MediaQuery.of(context).size.width,
                      // height: MediaQuery.of(context).size.height - 150,
                      ),
                ),
                Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Container(
                        width: double.infinity,
                        // height: MediaQuery.of(context).size.height - 200,
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0),
                          ),
                        ),

                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                dataManager.allFavImages.contains(
                                        dataManager.allImage[pageViewerIndex])
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.favorite,
                                          size: 35.0,
                                        ),
                                        color: Colors.red,
                                        onPressed: () {},
                                      )
                                    : IconButton(
                                        icon: Icon(Icons.favorite_border),
                                        onPressed: () {},
                                      ),
                                IconButton(
                                    icon: Icon(
                                      Icons.file_download,
                                      size: 35.0,
                                    ),
                                    onPressed: () async {
                                      await ImageDownloader.downloadImage(
                                        constant.SERVER_IMAGE_UPFOLDER_CATEGORY +
                                            dataManager
                                                .allImage[pageViewerIndex]
                                                .CatName
                                                .replaceAll(' ', '%20') +
                                            '/' +
                                            dataManager
                                                .allImage[pageViewerIndex]
                                                .urlImage,
                                        destination: AndroidDestinationType
                                            .directoryDownloads
                                          ..subDirectory("custom/sample.gif"),
                                      );
                                    }),
                                // Text(
                                //   !downloading
                                //       ? 'Not yet'
                                //       : 'Downloading $progressString',
                                //   style: widget.themeData.textTheme.body2,
                                // )
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
                            color: Colors.black,
                          ),
                          onPressed: () async {
                            var res = await _onsharePressed(context);
                            print(res);
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Icon(Icons.share),
                                    SizedBox(
                                      width: 12.0,
                                    ),
                                    Text("Please Wait..."),
                                  ],
                                ),
                              ),
                            );
                            var request = await HttpClient().getUrl(
                              Uri.parse(
                                constant.SERVER_IMAGE_UPFOLDER_CATEGORY +
                                    dataManager
                                        .allImage[pageViewerIndex].CatName
                                        .replaceAll(' ', '%20') +
                                    '/' +
                                    dataManager
                                        .allImage[pageViewerIndex].urlImage,
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
      ),
    );
  }
}
