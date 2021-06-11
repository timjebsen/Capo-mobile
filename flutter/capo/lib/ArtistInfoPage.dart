import 'package:flutter/material.dart';
import 'InfoPageAppBar.dart';
import 'funcs.dart';
import 'GigListCont.dart';
import 'GigModel.dart';
import 'AppBarInfoPage.dart';

class ArtistInfoPage extends StatefulWidget {
  const ArtistInfoPage({
    Key key,
    @required this.artistId,
    @required this.artistName,
    //@required this.context,
  }) : super(key: key);

  final String artistId;
  final String artistName;

  @override
  _ArtistInfoPageState createState() => _ArtistInfoPageState();
}

class _ArtistInfoPageState extends State<ArtistInfoPage> {
  Future<Map<String, dynamic>> _artistInfoFuture;
  Map<String, dynamic> artistInfo;
  Map<String, dynamic> socials;
  String name;
  String bio;
  Map region;
  List genres;
  Map s;
  GigsList upcoming;

  void loadData() {
    _artistInfoFuture = getArtistInfo(widget.artistId);
    _artistInfoFuture.then((response) {
      artistInfo = response;

      socials = artistInfo['artist_info']['socials'];
      name = artistInfo['artist_info']['name'];
      bio = artistInfo['artist_info']['bio'];
      region = artistInfo['artist_info']['region'];
      socials = artistInfo['artist_info']['socials'];
      genres = artistInfo['artist_info']['genre'];
      s = artistInfo['upcoming_events'];
      upcoming = GigsList.fromJson(artistInfo['upcoming_events']['gig_list']);
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    name = widget.artistName;
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: PreferredSize(
        //   preferredSize: Size.fromHeight(80),
        //   child: InfoPageAppBar(),
        // ),
        body: pageCont());
  }

  Widget pageCont() {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: FutureBuilder(
        future: _artistInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final artistInfo = snapshot.data;
            return CustomScrollView(
              // shrinkWrap: true,
              physics: globalScrollPhysics(),
              slivers: [
                AppBarInfoPage(text: name),
                artistInfoCont(context, artistInfo)
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
          AppBarInfoPage(text: widget.artistName),
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

  Widget socialsButton(text, value) {
    Color buttonColor = Theme.of(context).accentColor;
    if (text == 'Facebook') {
      buttonColor = hexToColor('#3b5998');
    } else if (text == 'Triple J') {
      buttonColor = hexToColor('#46812b');
    }
    ButtonStyle buttonSyle = ButtonStyle(
      elevation: MaterialStateProperty.all<double>(5),
      minimumSize: MaterialStateProperty.all<Size>(Size(100, 50)),
      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(5)),
      backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
      shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.0),
        ),
      ),
      textStyle: MaterialStateProperty.all<TextStyle>(
        TextStyle(color: Colors.white, fontSize: 25, fontFamily: 'Staatliches'),
      ),
    );
    return ElevatedButton(
      child: new Text(text),
      onPressed: () {},
      style: buttonSyle,
    );
  }

  // TODO Merge and make a global function for buildButtonArray from searchRegionPage
  List buildButtonArray() {
    List<Widget> buttonList = [];
    if (socials.length > 0) {
      for (MapEntry<String, dynamic> each in socials.entries) {
        if (each.value != null) {
          String buttonText;
          if (each.key == 'fb_link') {
            buttonText = "Facebook";
          } else if (each.key == 'website') {
            buttonText = "Website";
          } else if (each.key == 'triple_j') {
            buttonText = "Triple J";
          }
          if (buttonText != null) {
            buttonList.add(socialsButton(buttonText, each.value));
          }
        }
      }
    }
    return buttonList;
  }

  Widget socialButtonsContainer(Map socialsMap) {
    ButtonBar socialsButtonBar = ButtonBar(
      buttonPadding: EdgeInsets.all(0.0),
      alignment: MainAxisAlignment.spaceEvenly,
      children: buildButtonArray(),
    );
    return Container(child: socialsButtonBar);
  }

  Widget artistInfoCont(context, artistInfo) {
    double headingSize = 25;
    double headingWidth = 100;

    // Make global. Put into a styles file?
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
      // shrinkWrap: true,
      // physics: globalScrollPhysics(),
      delegate: SliverChildListDelegate(
        [
          // Header Image
          Container(
            child: Container(
              height: 180,
              color: Colors.grey[300],
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "PRESS SHOT\nIf available",
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 15,
                      fontFamily: 'Staatliches'),
                ),
              ),
            ),
          ),

          // Artist Header
          // Container(
          //   child: Text(name,
          //       textAlign: TextAlign.center,
          //       style: TextStyle(
          //         fontWeight: FontWeight.bold,
          //         color: Theme.of(context).accentColor,
          //         fontSize: 35,
          //         fontFamily: 'Staatliches',
          //       )),
          // ),

          (genres != null)
              ? Row(
                  children: <Widget>[
                    Padding(
                      padding: headingPadding,
                      child: Container(
                        width: headingWidth,
                        child: Text("Genre:", style: headingTextStyle),
                      ),
                    ),
                    Container(
                        child: Text(venueTypesToString(genres), style: contentTextStyle)),
                  ],
                )
              : SizedBox(),

          // Bio if not null
          (bio != null)
              ? Row(
                  //mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: headingPadding,
                      child: Container(
                        width: headingWidth,
                        child: Text("BIO:", style: headingTextStyle),
                      ),
                    ),
                    Flexible(
                      child: LayoutBuilder(builder: (context, size) {
                        var span = TextSpan(style: contentTextStyle, text: bio);

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
                              padding: const EdgeInsets.all(0.0),
                              child: Container(
                                child: RichText(
                                  maxLines: maxLines,
                                  overflow: TextOverflow.ellipsis,
                                  text:
                                      TextSpan(style: contentTextStyle, text: bio),
                                ),
                              ),
                            ),
                            (exceeded) ? readMoreButton() : SizedBox()
                          ],
                        );
                      }),
                    ),
                  ],
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
          (region != null)
              ? Row(
                  children: <Widget>[
                    Padding(
                      padding: headingPadding,
                      child: Container(
                        width: headingWidth,
                        child: Text("Region:", style: headingTextStyle),
                      ),
                    ),
                    Container(
                      child: Text.rich(
                        TextSpan(
                          style: contentTextStyle,
                          children: <TextSpan>[
                            TextSpan(text: region['region'] + ', '),
                            TextSpan(text: region['state_abr'])
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : SizedBox(),
          (socials != null)
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: headingPadding,
                          child: Container(
                            // width: ,
                            child: Text("Find $name on:", style: headingTextStyle),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: socialButtonsContainer(socials),
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
          (upcoming != null && upcoming.length > 0)
              ? Column(
                  children: [
                    Container(
                      child: Text(
                        "Upcoming Gigs!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                          fontFamily: 'Staatliches',
                          color: Theme.of(context).accentColor,
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

                            headerTitleKey = upcoming.gigs.keys.toList()[index];
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
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
