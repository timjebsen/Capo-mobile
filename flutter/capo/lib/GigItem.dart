import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import "funcs.dart";
import 'package:intl/intl.dart';
import 'Routes.dart';

class GigItemCard extends StatefulWidget {
  GigItemCard({
    GlobalKey key,
    @required this.context,
    @required this.groupMode,
    @required this.gigItemData,
  }) : super(key: key);

  final BuildContext context;

  final dynamic gigItemData;
  final int groupMode;

  @override
  _GigItemCardState createState() => _GigItemCardState();
}

class _GigItemCardState extends State<GigItemCard> {
  bool expanded;
  GlobalKey cardKey = GlobalKey();
  double cardSizeHeight;
  double cardSizeHeightOG = 72.0;
  double cardSizeHeightMax = 291;
  String venueName;
  String venueLineContent;
  String gigDate;
  List genre;

  void initState() {
    super.initState();
    setState(() {
      cardSizeHeight = cardSizeHeightOG;
    });
  }

  // void heightOfCard() {
  //   RenderBox box = cardKey.currentContext.findRenderObject() as RenderBox;
  //   cardSizeHeightOG = box.size.height;
  //   setState(() {
  //     cardSizeHeight = cardSizeHeightOG;
  //   });
  // }

  bool isExpanded() {
    if (cardSizeHeight == cardSizeHeightMax) {
      expanded = true;
    } else {
      expanded = false;
    }

    return expanded;
  }

  void expandCard() {
    setState(() {
      cardSizeHeight = cardSizeHeightMax;
    });
  }

  bool isShrinking = false;

  void shrinkCard() {
    setState(() {
      cardSizeHeight = cardSizeHeightOG;
    });
  }

  int maxLines = 6;

  void nothing() {}

  Widget readMoreButton() {
    return Container(
      alignment: Alignment(1.0, 0.0),
      child: OutlineButton(
        child: Text(
          "Read More",
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        onPressed: nothing,
        borderSide: BorderSide(color: Theme.of(context).accentColor),
      ),
    );
  }

  Widget mapButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Container(
        child: OutlineButton(
          child: Text(
            "Open Map",
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
          onPressed: nothing,
          borderSide: BorderSide(color: Theme.of(context).accentColor),
        ),
      ),
    );
  }

  Row infoRow(rowTitle, rowContent) {
    if (rowContent is List) {
      String genreText = '';
      for (int i = 0; i < rowContent.length; i++){
        if (i < rowContent.length - 1) {
          genreText += rowContent[i]+", ";
        } else {
          genreText += rowContent[i];
        }
      }
      rowContent = genreText;
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 65,
          child: Text(
            rowTitle + ":",
            // style: TextStyle(
            //   fontWeight: FontWeight.bold,
            //   fontSize: 30,
            //   fontFamily: 'Staatliches',
            //   color: Theme.of(context).accentColor,
            //   // shadows: <Shadow>[
            //   //   Shadow(
            //   //     blurRadius: 6.0,
            //   //     offset: Offset(2, 3),
            //   //     color: Color.fromARGB(50, 0, 0, 0),
            //   //   )
            //   // ],
            // ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: <Widget>[
              Container(
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(color: Colors.black), text: rowContent),
                ),
              ),
              //(rowTitle == "Venue") ? mapButton() : SizedBox()
            ],
          ),
        )
      ],
    );
  }

  Widget button(text, onPressed, color) {
    return OutlineButton(
      highlightedBorderColor: color,
      splashColor: color,
      child: Text(
        text,
        style: TextStyle(color: color),
      ),
      onPressed: onPressed,
      borderSide: BorderSide(color: color),
    );
  }

  Widget moreInfoButtons(artistId, venueId, artistName) {
    return ButtonBar(
      alignment: MainAxisAlignment.spaceEvenly,
      //mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        button("Open Map", nothing, Theme.of(context).accentColor),
        button("Artist Details", () => artistPage(context, artistId, artistName),
            Theme.of(context).accentColor),
        button("Venue Details", () => venuePage(context, venueId), Theme.of(context).accentColor),
      ],
    );
  }

  Widget expandedGigItem(artistId, venueId, genre, artistName) {
    return Padding(
      padding: EdgeInsets.only(top: 3.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black26, width: 2)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Column(
            children: <Widget>[
              infoRow("Venue", venueLineContent),
              lineSeperator(),
              infoRow("Date", gigDate),
              lineSeperator(),
              infoRow("Entry Cost", "Usually free entry"),
              lineSeperator(),
              infoRow("Genre", genre),
              lineSeperator(),
              moreInfoButtons(artistId, venueId, artistName)
              // (widget.gigItemData.bio != null) ? bioRow() : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget lineSeperator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12, width: 2)),
        ),
      ),
    );
  }

  Row bioRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 50,
          child: Text(
            "BIO:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              fontFamily: 'Staatliches',
              color: Theme.of(context).accentColor,
              // shadows: <Shadow>[
              //   Shadow(
              //     blurRadius: 6.0,
              //     offset: Offset(2, 3),
              //     color: Color.fromARGB(50, 0, 0, 0),
              //   )
              // ],
            ),
          ),
        ),
        Flexible(
          child: LayoutBuilder(builder: (context, size) {
            var span = TextSpan(
                style: TextStyle(color: Colors.black),
                text: widget.gigItemData.bio);

            var tp = TextPainter(
              maxLines: 6,
              textAlign: TextAlign.left,
              // textDirection: TextDirection.ltr,
              text: span,
            );

            tp.layout(maxWidth: size.maxWidth);

            var exceeded = tp.didExceedMaxLines;
            // return Text(exceeded.toString());
            return Column(
              children: <Widget>[
                Container(
                  child: RichText(
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        text: widget.gigItemData.bio),
                  ),
                ),
                (exceeded) ? readMoreButton() : SizedBox()
              ],
            );
          }),
        ),
      ],
    );
  }

  void hideExtraGigInfo() {
    isShrinking = false;
    // set state to update view to remove extra info container
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO get venue data
    venueName = widget.gigItemData.venueName.toString();

    gigDate = formatGroupTitle(0, widget.gigItemData.time.toString())
            .toString() +
        " " +
        DateFormat('EEEE d MMMM')
            .format(DateFormat("yyyy-MM-dd").parse(widget.gigItemData.date));

    String venueAddress = "1/210 Wickham St,\nFortitude Valley QLD 4006";
    venueLineContent = venueName + "\n" + venueAddress;
    genre = widget.gigItemData.genre;

    return AnimatedContainer(
      curve: Curves.easeInOut,
      onEnd: hideExtraGigInfo,
      key: cardKey,
      height: cardSizeHeight,
      duration: Duration(milliseconds: 200),
      child: Card(
        elevation: 5,
        // shape: Border(),
        color: hexToColor('#ebebeb'),
        child: InkWell(
          excludeFromSemantics: true,
          splashColor: Theme.of(context).accentColor.withAlpha(100),
          onTap: () {
            if (!isExpanded()) {
              expandCard();
            } else {
              isShrinking = true;
              shrinkCard();
            }
          },
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          height: 35,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              widget.gigItemData.artistName.toString(),

                              // +
                              // " at " +
                              // formatGroupTitle(0,
                              //     gigs.gigs[headerTitleKey][k].time.toString()).toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                 color: Theme.of(context).accentColor,
                              ),
                            ),
                          ),
                        ),
                        Container(
                            height: 30,
                            child: (() {
                              if (widget.groupMode == 0) {
                                if (widget.gigItemData.ticket == null) {
                                  return FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      "Free!",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).accentColor),
                                    ),
                                  );
                                } else {
                                  return FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      widget.gigItemData.ticket.toString(),
                                      style: TextStyle(
                                          //fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  );
                                }
                              } else if (widget.groupMode == 1) {
                                return FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    formatGroupTitle(0,
                                            widget.gigItemData.time.toString())
                                        .toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        // color: Theme.of(context).accentColor
                                        ),
                                  ),
                                );
                              }
                              return Text("No such group mode: " +
                                  widget.groupMode.toString());
                            }())),
                      ]),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.only(right: 15.0),
                          height: 25,
                          // color: Colors.pink,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              widget.gigItemData.venueName.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 25,
                        // color: Colors.pink,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            widget.gigItemData.suburb.toString(),
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  (isExpanded() || isShrinking)
                      ? expandedGigItem(widget.gigItemData.artistId, widget.gigItemData.venueId, genre, widget.gigItemData.artistName)
                      : SizedBox(),
                ],
              )),
        ),
      ),
    );
  }
}
