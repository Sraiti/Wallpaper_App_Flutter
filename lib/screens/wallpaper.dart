import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/data/dbManager.dart';
import 'package:flutter_app/models/image.dart';
import 'package:flutter_app/models/itemImage.dart';
import 'package:flutter_app/util/constant.dart';
import 'package:flutter_app/util/util.dart';
import 'package:http/http.dart' as http;
import 'package:image_downloader/image_downloader.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pedantic/pedantic.dart';
import 'package:flutter_app/util/widgets.dart';

import 'package:provider/provider.dart';

allImage alldatanotif;

class WallpaperPage extends StatelessWidget {
  WallpaperPage({this.heroId, this.allimage});

  static const String id = "wallpaper";
  final int heroId;
  final List<itemImage> allimage;

  //var alldata = data.getInstance();

  Widget myBody(BuildContext context) {
    Provider.of<allImage>(context, listen: false).changeimage(allimage[heroId]);
    return Scaffold(
      body: Consumer<allImage>(builder: (context, temp, child) {
        return SafeArea(
          child: Stack(
            children: <Widget>[
              CarouselSlider.builder(
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                itemCount: allimage.length,
                height: double.infinity,
                initialPage: heroId,
                onPageChanged: (index) {
                  temp.changeimage(allimage[index]);
                },
                itemBuilder: (BuildContext context, int itemIndex) => Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomLeft,
                            colors: [Colors.deepPurple, Colors.blue]),
                      ),
                    ),
                    itemIndex != 4
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 0.0),
                            child: Hero(
                              tag: heroId,
                              child: CachedNetworkImage(
                                width: MediaQuery.of(context).size.width,
                                height: double.infinity,
                                imageUrl:
                                    constant.SERVER_IMAGE_UPFOLDER_CATEGORY +
                                        'bom-dia/' +
                                        allimage[itemIndex].urlImage,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
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
                          )
                        : NativeAd(),
                  ],
                ),
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
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0))),

                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  temp.image.isfav == 1
                                      ? IconButton(
                                          icon: Icon(Icons.favorite),
                                          color: Colors.red,
                                          onPressed: () {
                                            temp.deletefav();
                                            temp.setfav(0);
                                          },
                                        )
                                      : IconButton(
                                          icon: Icon(Icons.favorite_border),
                                          onPressed: () {
                                            temp.addToFav();
                                            temp.setfav(1);
                                          },
                                        ),
                                  IconButton(
                                      icon: Icon(Icons.file_download),
                                      onPressed: () async {
                                        await ImageDownloader.downloadImage(
                                          constant.SERVER_IMAGE_UPFOLDER_CATEGORY +
                                              'bom-dia/' +
                                              temp.image.urlImage,
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

                              var request = await HttpClient().getUrl(Uri.parse(
                                  constant.SERVER_IMAGE_UPFOLDER_CATEGORY +
                                      'bom-dia/' +
                                      temp.image.urlImage));
                              var response = await request.close();
                              Uint8List bytes =
                                  await consolidateHttpClientResponseBytes(
                                      response);
                              await Share.file(
                                  'ESYS AMLOG', 'amlog.jpg', bytes, 'image/jpg',
                                  text: 'this my text');
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
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return myBody(context);
  }
}
