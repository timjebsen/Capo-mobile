import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import "funcs.dart";
import 'package:intl/intl.dart';
import 'Routes.dart';
import 'VenueModel.dart';

class VenueItemCard extends StatefulWidget {
  VenueItemCard({
    GlobalKey key,
    @required this.context,
    @required this.venueData,
  }) : super(key: key);

  final BuildContext context;
  final VenueModel venueData;

  @override
  _VenueItemCardState createState() => _VenueItemCardState();
}

class _VenueItemCardState extends State<VenueItemCard> {
  bool expanded;
  GlobalKey cardKey = GlobalKey();
  double cardSizeHeight;
  double cardSizeHeightOG = 73.0;
  double cardSizeHeightMaxOG = 228;
  double cardSizeHeightMaxNew;
  String venueName;
  String venueSuburb;
  List venueType;
  String venueLineContent;
  String description;
  bool openStatus;
  bool hasImage;
  Map<String, dynamic> imageLinks;
  String coverCharge;
  double imageHeight = 150;
  void initState() {
    super.initState();
    setState(() {
      // If has image. Change default card height
      // TODO update with real values
      if (true) {
        cardSizeHeightOG += imageHeight;
        cardSizeHeightMaxOG += imageHeight;
      }
      if (description == null) {
        cardSizeHeightMaxNew = cardSizeHeightMaxOG - 65;
      }
      if (coverCharge == null) {
        cardSizeHeightMaxNew = cardSizeHeightMaxOG - 65;
      }
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
    if (cardSizeHeight == cardSizeHeightMaxNew) {
      expanded = true;
    } else {
      expanded = false;
    }

    return expanded;
  }

  void expandCard() {
    setState(() {
      cardSizeHeight = cardSizeHeightMaxNew;
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
      for (int i = 0; i < rowContent.length; i++) {
        if (i < rowContent.length - 1) {
          genreText += rowContent[i] + ", ";
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

  Widget moreInfoButtons(venueId) {
    return ButtonBar(
      alignment: MainAxisAlignment.spaceEvenly,
      //mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        button("Open Map", nothing, Theme.of(context).accentColor),
        button("Upcoming Events", nothing, Theme.of(context).accentColor),
        button("More Details", () => venuePage(context, venueId),
            Theme.of(context).accentColor),
      ],
    );
  }

  Widget expandedVenueItem(description, venueId) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black26, width: 2)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: <Widget>[
              (description != null)
                  ? infoRow(
                      "Description",
                      "line1<venueData.description>\nline2<venueData.description>" +
                          description.toString())
                  : SizedBox(),
              (description != null) ? lineSeperator() : SizedBox(),
              (false)
                  ? infoRow("Entry Cost", "<venueData.coverCharge>")
                  : SizedBox(),
              (false) ? lineSeperator() : SizedBox(),
              moreInfoButtons(venueId)
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

  void hideExtraGigInfo() {
    isShrinking = false;
    // set state to update view to remove extra info container
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // cardSizeHeightMaxNew = widget.venueData;
    venueName = widget.venueData.venueName;
    venueSuburb = widget.venueData.suburb;
    description = widget.venueData.description;
    openStatus = widget.venueData.openStatus;
    venueType = widget.venueData.venueType;
    hasImage = widget.venueData.hasImage;
    imageLinks = widget.venueData.imageLinks;

    String coverCharge;
    bool hasImageLinks = false;

    // * If has_image. Check for image links existence
    // * if not, update has_image to false
    // This is a double check for image links existence
    //  because has_image might return true, but an
    // error could have ocurred building image links
    // returning an empty map, rasining an error when 
    // trying to read
    if (hasImage && imageLinks != null){
      if(imageLinks == {} || imageLinks.isEmpty || imageLinks == null){
        hasImage = false;
      } else {
        hasImage = true;
      }
    } else {
      hasImage = false;
    }


    String venueAddress = widget.venueData.address;
    venueLineContent = venueName + "\n" + venueAddress;

    return Column(
      children: [
        AnimatedContainer(
          curve: Curves.easeInOut,
          onEnd: hideExtraGigInfo,
          key: cardKey,
          height: (hasImage) ? cardSizeHeight : cardSizeHeight - imageHeight,
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
                  padding: EdgeInsets.only(
                      left: 0.0, right: 0.0, top: 0.0, bottom: 2.0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      (hasImage)
                          ? Padding(
                            padding: const EdgeInsets.only(bottom: 2.0),
                            child: Container(
                                height: imageHeight,
                                // color: Colors.amber,
                                width: 1000,
                                child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                  child: Opacity(opacity: 0.8,
                                      child: Image.network(
                                      imageLinks.entries.first.value,
                                      fit: BoxFit.cover,
                                      // color: Colors.transparent,
                                    ),
                                  ),
                                )),
                          )
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                fit: FlexFit.loose,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Container(
                                    height: 35,
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        venueName,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                  height: 25,
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      (openStatus != null) ? openStatus ? "Open Now!" : "Closed" : " ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).accentColor),
                                    ),
                                  ))
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.only(right: 15.0),
                                height: 25,
                                // color: Colors.pink,
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    venueSuburb, //venueTypeString,
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
                                  venueTypesToString(venueType), //venueIsOpen,
                                  style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    //color: Theme.of(context).accentColor
                                  ),
                                ),
                              ),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                      ),
                      (isExpanded() || isShrinking)
                          ? expandedVenueItem(widget.venueData.description,
                              widget.venueData.venueId)
                          : SizedBox(),
                    ],
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
