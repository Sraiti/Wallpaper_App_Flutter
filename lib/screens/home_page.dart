import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/dbManager.dart';

import 'package:flutter_app/models/image.dart';
import 'package:flutter_app/models/itemImage.dart';
import 'package:flutter_app/screens/wallpaper.dart';
import 'package:flutter_app/util/constant.dart';
import 'package:flutter_app/util/sqlite.dart';
import 'package:flutter_app/util/widgets.dart';
import 'package:provider/provider.dart';
import 'favorites.dart';

class homepage extends StatelessWidget {
  static final String id = "homepage";
  var alldata = data.getInstance();
  Future<List<itemImage>> getfav() async {
    var dbhepler = DBHelper();
    Future<List<itemImage>> favs = dbhepler.getfavorites();

    return favs;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              ShowMore(
                  text: 'Favorites',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Favorites(),
                      ),
                    );
                  }),
              FutureBuilder<List>(
                future: Provider.of<DataProvider>(context).getfav(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return favoriteSlider(allfav: snapshot.data);
                  } else if (snapshot.hasError)
                    return Container(child: Text("error"));
                  else
                    return Container(
                        child:
                            Text("feils")); //favoriteSlider(alldata: alldata);
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Latest",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontFamily: 'Caveat',
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: alldata.allImage.length == null
                      ? 0
                      : alldata.allImage.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WallpaperPage(
                                heroId: index,
                                allimage: alldata.allImage,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: <Widget>[
                            Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                height: 70,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Hero(
                                    tag: index,
                                    child: CachedNetworkImage(
                                      imageUrl: constant
                                              .SERVER_IMAGE_UPFOLDER_CATEGORY +
                                          'Good%20Evening/' +
                                          alldata.allImage[index].urlImage,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          Image.asset(
                                        'assets/images/loading.gif',
                                        fit: BoxFit.cover,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void showToast(text, context) {
    //Toast.show(text, context,
    //duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }
}

class favoriteSlider extends StatefulWidget {
  const favoriteSlider({
    Key key,
    @required this.allfav,
  }) : super(key: key);

  final List<itemImage> allfav;

  @override
  _favoriteSliderState createState() => _favoriteSliderState();
}

class _favoriteSliderState extends State<favoriteSlider> {
  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < widget.allfav.length; i++)
      print(widget.allfav[i].urlImage);

    return Column(
      children: <Widget>[
        widget.allfav.length != 0
            ? Container(
                color: Colors.red.withAlpha(15),
                child: CarouselSlider.builder(
                    itemCount: widget.allfav.length,
                    viewportFraction: 0.3,
                    autoPlay: true,
                    height: 100.0,
                    itemBuilder: (BuildContext context, int itemIndex) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: <Widget>[
                                Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WallpaperPage(
                                            heroId: itemIndex,
                                            allimage: widget.allfav,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 100,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: CachedNetworkImage(
                                          imageUrl: constant
                                                  .SERVER_IMAGE_UPFOLDER_CATEGORY +
                                              'Good%20Evening/' +
                                              widget.allfav[itemIndex].urlImage,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              Image.asset(
                                            'assets/images/loading.gif',
                                            fit: BoxFit.cover,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
              )
            : Container()
        /* CarouselSlider(
          autoPlay: true,
          height: 100.0,
          viewportFraction: 0.4,
          items: allfav.map((index) {
            return Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: <Widget>[
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: FadeInImage(
                                image: NetworkImage(allfav[index]),
                                fit: BoxFit.cover,
                                placeholder:
                                    AssetImage('assets/images/loading.gif'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),*/
      ],
    );
  }
}
