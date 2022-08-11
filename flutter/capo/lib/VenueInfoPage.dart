import 'package:flutter/material.dart';
import 'package:capo/VenueModel.dart';
import 'AppBarInfoPage.dart';
import 'funcs.dart';
import 'GigListCont.dart';
import 'GigModel.dart';
import 'package:carousel_slider/carousel_slider.dart';

class VenueInfoPage extends StatefulWidget {
  const VenueInfoPage({
    Key key,
    @required this.venueId,
    this.venueName,
    //@required this.venueId,
  }) : super(key: key);

  final String venueId;
  final String venueName;

  @override
  _VenueInfoPageState createState() => _VenueInfoPageState();
}

class _VenueInfoPageState extends State<VenueInfoPage> {
  Future<Map<String, dynamic>> _venueInfoAllFuture;
  Map<String, dynamic> venueDataAll;
  VenueModel venueInfo;
  GigsList upcoming;

  void loadData() {
    _venueInfoAllFuture = getVenueInfo(widget.venueId);
    _venueInfoAllFuture.then((response) {
      venueDataAll = response;
      venueInfo = venueDataAll["venueInfo"];
      upcoming = venueDataAll["upcoming"];
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageCont(),

      // child: FutureBuilder(
      //   future: _venueInfoFuture,
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       final venueInfo = snapshot.data;
      //       if(venueInfo == null){
      //         return Text('Something went wrong. No data for requested venue');
      //       } else {
      //         return venueInfoCont(context, venueInfo);
      //       }

      //     } else {
      //       return CircularProgressIndicator();
      //     }
      //   },
      // ),
    );
  }

  Widget pageCont() {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: FutureBuilder(
        future: _venueInfoAllFuture,
        builder: (context, _venueInfoAllFuture) {
          if (_venueInfoAllFuture.hasData) {
            return CustomScrollView(
              // shrinkWrap: true,
              physics: globalScrollPhysics(),
              slivers: [
                AppBarInfoPage(text: venueInfo.venueName),
                venueInfoCont()
              ],
            );
          } else {
            return pageLoading();
          }
        },
      ),
    );
  }

  // Seperate page to display while loading. Mostly used to draw appbar while data is retrieved
  Widget pageLoading() {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: CustomScrollView(
        slivers: [
          AppBarInfoPage(text: widget.venueName),
          centerSliverProgressIndicator(context),
        ],
      ),
    );
  }

  Widget readMoreButton() {
    return Container(
      alignment: Alignment(0.0, 0.0),
      child: OutlineButton(
        child: Text(
          "Read More",
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        onPressed: () => {},
        borderSide: BorderSide(color: Theme.of(context).accentColor),
      ),
    );
  }

  bool hasSocials(Map socialsMap) {
    bool isNotEmpty = false;
    for (String each in socialsMap.values) {
      if (each != null) {
        isNotEmpty = true;
      }
    }
    return isNotEmpty;
  }

  Widget venueInfoCont() {
    //print(venueInfo);
    String venueName = venueInfo.venueName;
    String description = venueInfo.description;
    String suburb = venueInfo.suburb;
    Map<String, dynamic> socials = venueInfo.socials;
    String address = venueInfo.address;
    List<dynamic> hours = venueInfo.hours;
    List venueType = venueInfo.venueType;
    bool hasImage = venueInfo.hasImage;
    Map<String, dynamic> imageLinks = venueInfo.imageLinks;

    // Create a list of numbers for each image link used for the iterator
    List<int> imagesIndex = [];
    if (imageLinks != null) {
      for (int i = 0; i < imageLinks.length; i++) {
        imagesIndex.add(i);
      }
    }

    double headingSize = 25;
    double headingWidth = 100;

    // TODO Make global. Put into a styles file?
    TextStyle headingTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: headingSize,
      fontFamily: 'Staatliches',
      color: Theme.of(context).primaryColor.withOpacity(0.5),
    );
    TextStyle contentTextStyle = TextStyle(
      // fontWeight: FontWeight.bold,
      fontSize: 18,
      fontFamily: 'Archivo',
      fontWeight: FontWeight.bold,
      color: Theme.of(context).primaryColor.withOpacity(0.9),
    );
    TextStyle mainHeadingStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 35,
      fontFamily: 'Staatliches',
      color: Theme.of(context).accentColor,
    );

    EdgeInsets headingPadding = EdgeInsets.only(left: 8.0);
    EdgeInsets conentPadding = EdgeInsets.symmetric(horizontal: 8.0);
    EdgeInsets rowPadding = EdgeInsets.symmetric(vertical: 8.0);
    int maxLines = 10;

    
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          // Header Image
          (hasImage)
              ? Container(
                  child: Container(
                      // height: 210,
                      color: Theme.of(context).backgroundColor,
                      child: CarouselSlider(
                        options: CarouselOptions(height: 300.0),
                        items: imagesIndex.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(),
                                child: Image.network(
                                  imageLinks[i.toString()],
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          );
                        }).toList(),
                      )

                      // Image.network(
                      //                     imageLinks.entries.first.value,
                      //                     fit: BoxFit.cover,
                      //                   ),
                      // Text(
                      //   "PRESS SHOT\nImage Carousel",
                      //   style: TextStyle(
                      //       color: Theme.of(context).accentColor,
                      //       fontSize: 25,
                      //       fontFamily: 'Staatliches'),
                      // ),

                      ),
                )
              : SizedBox(),

          // venue Header
          // Container(
          //   child: Text(name,
          //       textAlign: TextAlign.left,
          //       style: TextStyle(
          //         color: Theme.of(context).accentColor,
          //         fontSize: 35,
          //         fontFamily: 'Staatliches',
          //         shadows: <Shadow>[
          //           Shadow(
          //             blurRadius: 6.0,
          //             offset: Offset(2, 3),
          //             color: Color.fromARGB(50, 0, 0, 0),
          //           )
          //         ],
          //       )),
          // ),

          (suburb != null)
              ? Padding(
                  padding: rowPadding,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          width: headingWidth,
                          child: Text(
                            "Suburb:",
                            style: headingTextStyle,
                          ),
                        ),
                      ),
                      Padding(
                        padding: conentPadding,
                        child: Container(
                            child: Text(
                          suburb,
                          style: contentTextStyle,
                        )),
                      )
                    ],
                  ),
                )
              : SizedBox(),

          (venueType != null && venueType != [])
              ? Padding(
                  padding: rowPadding,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          width: headingWidth,
                          child: Text(
                            "Type:",
                            style: headingTextStyle,
                          ),
                        ),
                      ),
                      Padding(
                          padding: conentPadding,
                          child: Text(venueTypesToString(venueType),
                              style: contentTextStyle)),
                    ],
                  ),
                )
              : SizedBox(),

          (hours != null && hours != [])
              ? Padding(
                  padding: rowPadding,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          width: headingWidth,
                          child: Text(
                            "Hours:",
                            style: headingTextStyle,
                          ),
                        ),
                      ),
                      Padding(
                          padding: conentPadding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: listToText(hours, contentTextStyle),
                          )),
                    ],
                  ),
                )
              : SizedBox(),

          // Bio if not null
          (description != null)
              ? Padding(
                  padding: rowPadding,
                  child: Row(
                    //mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          width: headingWidth,
                          child: Text(
                            "BIO:",
                            style: headingTextStyle,
                          ),
                        ),
                      ),
                      Flexible(
                        child: LayoutBuilder(builder: (context, size) {
                          var span = TextSpan(
                              style: TextStyle(color: Colors.black),
                              text: "description");

                          var tp = TextPainter(
                            maxLines: maxLines,
                            textAlign: TextAlign.left,
                            textDirection: TextDirection.ltr,
                            text: span,
                          );

                          tp.layout(maxWidth: size.maxWidth);

                          var exceeded = tp.didExceedMaxLines;
                          print(exceeded);
                          // return Text(exceeded.toString());
                          return Column(
                            children: <Widget>[
                              Padding(
                                padding: conentPadding,
                                child: Container(
                                  child: RichText(
                                    maxLines: maxLines,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                        style: contentTextStyle,
                                        text: "description"),
                                  ),
                                ),
                              ),
                              (exceeded) ? readMoreButton() : SizedBox()
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                )
              // ? Container(
              //     child: Row(
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Text(
              //             'Bio:',
              //             style: TextStyle(
              //                 color: Theme.of(context).accentColor,
              //                 fontSize: 26,
              //                 fontFamily: 'Staatliches'),
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Text(
              //             bio,
              //             overflow: TextOverflow.ellipsis,
              //             maxLines: 10,
              //             //style: TextStyle(color: )

              //           ),
              //         )
              //       ],
              //     ),
              //   )
              : SizedBox(),
          (address != null)
              ? Padding(
                  padding: rowPadding,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          width: headingWidth,
                          child: Text(
                            "Location:",
                            style: headingTextStyle,
                          ),
                        ),
                      ),
                      Padding(
                        padding: conentPadding,
                        child: Container(
                          child: Text.rich(
                            TextSpan(
                              style: TextStyle(color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                  text: address,
                                  style: contentTextStyle,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          (hasSocials(socials) != false)
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: headingPadding,
                          child: Container(
                            // width: ,
                            child: Text("Find $venueName at:",
                                style: headingTextStyle),
                          ),
                        ),
                        Padding(
                          padding: conentPadding,
                          child: Container(
                            child: socialButtonsContainer(context, socials),
                          ),
                        )
                      ]),
                )
              //       child: Row(
              //         children: genres
              //             .map(
              //               (item) => Container(
              //                 child: Padding(
              //                   padding: const EdgeInsets.all(3.0),
              //                   child: Text(
              //                     item,
              //                     style: contentTextStyle,
              //                   ),
              //                 ),
              //               ),
              //             )
              //             .toList(),
              //       ),
              //     ),
              //   ],
              // )
              : SizedBox(),
          (upcoming.length != 0)
              ? Padding(
                  padding: rowPadding,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          child: Text(
                            "Upcoming Gigs!",
                            style: mainHeadingStyle,
                          ),
                        ),
                      ),
                      Container(
                        //height: 2000,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(0.0),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: upcoming.gigs.length,
                          itemBuilder: (BuildContext context, int index) {
                            while (index < upcoming.gigs.length) {
                              var headerTitleKey;
                              var headerTitleFormatted;

                              headerTitleKey =
                                  upcoming.gigs.keys.toList()[index];
                              print(headerTitleKey);
                              headerTitleFormatted =
                                  formatGroupTitle(1, headerTitleKey);

                              return GigListContainer(
                                context: context,
                                index: index,
                                gigs: upcoming,
                                headerTitleKey: headerTitleKey,
                                headerTitleFormatted: headerTitleFormatted,
                                groupMode: 1,
                                numOfGigs: upcoming.gigs.length,
                                vis: true,
                                refPage: 1,
                              );
                            }
                            return SizedBox();
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
