import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/dbManager.dart';
import 'package:flutter_app/models/image.dart';
import 'package:flutter_app/models/itemImage.dart';
import 'package:flutter_app/util/constant.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:permission_handler/permission_handler.dart';

class WallpaperPage extends StatefulWidget {
  static final String id = "wallpaper";
  final int heroId;
  final List<itemImage> allimage;
  var filePath;

  WallpaperPage({@required this.heroId, @required this.allimage});
  @override
  _WallpaperPageState createState() => _WallpaperPageState();
}

class _WallpaperPageState extends State<WallpaperPage> {
  bool downloading = false;
  var progressString = "";
  var alldata = data.getInstance();

  itemImage currentImage;
  Future<void> downloadImage() async {}

  @override
  void initState() {
    super.initState();
  }

  Widget myBody(BuildContext context) {
    Provider.of<DataProvider>(context, listen: false)
        .setcurrentImage(widget.allimage[widget.heroId]);
    currentImage = Provider.of<DataProvider>(context).current;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black45,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              CarouselSlider.builder(
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                itemCount: widget.allimage.length,
                height: double.infinity,
                initialPage: widget.heroId,
                onPageChanged: (index) {
                  /*Provider.of<DataProvider>(context, listen: false)
                      .setcurrentImage(widget.allimage[index]);
                  currentImage = Provider.of<DataProvider>(context).current;*/
                  currentImage = widget.allimage[index];
                },
                itemBuilder: (BuildContext context, int itemIndex) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 0.0),
                  child: Hero(
                    tag: widget.heroId,
                    child: CachedNetworkImage(
                      width: MediaQuery.of(context).size.width,
                      height: double.infinity,
                      imageUrl: constant.SERVER_IMAGE_UPFOLDER_CATEGORY +
                          'Good%20Evening/' +
                          widget.allimage[itemIndex].urlImage,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Image.asset(
                        'assets/images/loading.gif',
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.error,
                        color: Colors.white,
                      ),
                    ),
                  ),
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
                  utilBar(
                      widget: widget,
                      currentImage: Provider.of<DataProvider>(context).current)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return myBody(context);
  }
}

class utilBar extends StatelessWidget {
  const utilBar({
    Key key,
    @required this.widget,
    @required this.currentImage,
  }) : super(key: key);

  final WallpaperPage widget;
  final itemImage currentImage;

  _savePhoto(context) {}

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                    currentImage.isfav == 1
                        ? IconButton(
                            icon: Icon(Icons.favorite),
                            color: Colors.red,
                            onPressed: () {
                              currentImage.isfav = 0;
                              Provider.of<DataProvider>(context, listen: false)
                                  .deletefav(currentImage);
                            },
                          )
                        : IconButton(
                            icon: Icon(Icons.favorite_border),
                            onPressed: () {
                              currentImage.isfav = 1;
                              Provider.of<DataProvider>(context, listen: false)
                                  .addToFav(currentImage);
                            },
                          ),
                    IconButton(
                      icon: Icon(Icons.file_download),
                      onPressed: () {
                        if (PermissionHandler().checkPermissionStatus(
                                PermissionGroup.storage) !=
                            PermissionStatus.granted)
                          PermissionHandler().requestPermissions([
                            PermissionGroup.storage
                          ]).then(_savePhoto(context));
                        // setState(() {
                        //   downloading = true;
                        // });
                        // downloadImage();
                      },
                    ),
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
            onPressed: () async {},
          ),
        )
      ],
    );
  }

  void _onload(bool t) {
    if (t) {
      showDialg(context: context);
    }
  }
}
