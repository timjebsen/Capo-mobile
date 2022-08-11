// import 'dart:html';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'AppBarRegSearch.dart';
import 'DefaultAppBar.dart';
import 'funcs.dart';
import 'GigListCont.dart';
import 'GigModel.dart';
import 'VenueModel.dart';
import 'VenueItem.dart';

class SearchRegionPage extends StatefulWidget {
  const SearchRegionPage({
    Key key,
    @required this.regionId,
    @required this.regionName,
    //@required this.venueId,
  }) : super(key: key);

  final String regionId;
  final String regionName;

  @override
  _SearchRegionPageState createState() => _SearchRegionPageState();
}

class _SearchRegionPageState extends State<SearchRegionPage>
    with TickerProviderStateMixin {
  Future<Map<String, dynamic>> _searchRegionDataFuture;
  Map<String, dynamic> searchRegionData;
  bool isVenueFilterOn = false;
  bool isVenueViewOn = false;
  bool isGigListViewOn = true;
  GigsList upcoming;
  VenueList venues;
  Map meta;
  AnimationController gigListAnimationController;
  Animation<Offset> gigListAnimation;

  AnimationController venueListAnimationController;
  Animation<Offset> venueListAnimation;

  AnimationController filterAnimationController;
  Animation<double> filterAnimation;

  bool isTransisioning = false;
  bool firstLoad = true;

  // Needs to be global because list length is defined before future is called
  int numOfTimeSlots = 0;
  int numOfVenues = 0;
  // int numOfVenuesWFilter = 0;

  void loadData() {
    _searchRegionDataFuture = getSearchRegion(widget.regionId);
    _searchRegionDataFuture.then((response) {
      searchRegionData = response;
      searchRegionData['upcoming_events']['gig_list']
          .forEach((k, v) => numOfTimeSlots += 1);
      numOfVenues = searchRegionData['venues_list'].length;
      // print(numOfVenues);
      venues = VenueList.fromJson(searchRegionData['venues_list']);
      buildVenueTypeList();
      // numOfVenuesWFilter = numOfVenues;
    });
    setState(() {});
  }

  // Set up all the animation controllers at initialisation
  @override
  void initState() {
    super.initState();
    loadData();
    gigListAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    venueListAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    filterAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    gigListAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(-1, 0),
    ).animate(gigListAnimationController
        .drive(CurveTween(curve: Curves.fastOutSlowIn)))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            isGigListViewOn = false;
          });
        }
      });
    venueListAnimation = Tween<Offset>(
      begin: Offset(1, 0),
      end: Offset(0, 0),
    ).animate(venueListAnimationController
        .drive(CurveTween(curve: Curves.fastOutSlowIn)))
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          setState(() {
            isVenueViewOn = false;
          });
        }
      });
    filterAnimation = CurvedAnimation(
      parent: filterAnimationController,
      curve: Curves.fastOutSlowIn,
    );

    setState(() {});
  }

  Widget _gigListBuilder(
      BuildContext context, int index, Animation<double> animation) {
    while (index < numOfTimeSlots) {
      // print('building gig list. Index: ' + index.toString());
      var headerTitleKey;
      var headerTitleFormatted;
      headerTitleKey = upcoming.gigs.keys.toList()[index];
      headerTitleFormatted =
          formatGroupTitle(meta['group_mode'], headerTitleKey);

      return SlideTransition(
        position: gigListAnimation,
        child: GigListContainer(
          context: context,
          index: index,
          gigs: upcoming,
          headerTitleKey: headerTitleKey,
          headerTitleFormatted: headerTitleFormatted,
          groupMode: meta['group_mode'],
          numOfGigs: meta['num_of_obj'],
          vis: true,
          refPage: 0,
        ),
      );
    }
    return Text('');
  }

  // Define list of venue types to be used in filter buttons
  // TODO deprecate and move venue_type array to metada in response
  List venueTypes = [];
  Map<String, bool> buttonStates = {};
  void buildVenueTypeList() {
    for (int i = 0; i < numOfVenues; i++) {
      for (int h = 0; h < venues[i].venueType.length; h++) {
        if (!venueTypes.contains(venues[i].venueType[h])) {
          if (venues[i].venueType[h] == 'Locality') {
          } else {
            venueTypes.add(venues[i].venueType[h]);
          }
        }
      }
    }
    buttonStates = {};
    for (int i = 0; i < venueTypes.length; i++) {
      // print(i);
      buttonStates[venueTypes[i]] = true;
    }
  }

  List<Widget> buildFilterArray() {
    List<Widget> buttonList = [];
    if (buttonStates.length > 0) {
      for (MapEntry<String, bool> each in buttonStates.entries) {
        buttonList.add(extraFilterButton(each.key, each.value));
      }
    }
    return buttonList;
  }

  Widget moreFilterButtons() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(
                color: Theme.of(context).primaryColor.withAlpha(30), width: 3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // color: Colors.amberAccent,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                // color: Colors.amberAccent,
                child: Text(
                  'Venue Type',
                  style: TextStyle(fontSize: 15, fontFamily: 'Staatliches'),
                ),
              ),
              Container(
                // color: Colors.amberAccent,

                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  spacing: 40.0,
                  children: buildFilterArray(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  VenueList removedItems;

  /// * to implements adding and removing animations from list. "removeAt" needs to be called.
  /// * This deletes from memorey and cannot be re-added. 2 Seperate lists need to be used.
  /// * One containing the full list of items, and one that can be modified that is used to
  /// * display the list on screen. This way, items can be added back to the modified list from the og list.
  /// * or add a "removedItems list", that stores the removed items in memory than adds them back when needed
  // void _removeVenueItems(){
  //   // Check if all value arr same. If true return full venue list
  //       bool oldBool;
  //       bool allSame;
  //       for (MapEntry<String, bool> each in buttonStates.entries) {
  //         bool newBool = each.value;
  //         if (oldBool == null) {
  //           oldBool = each.value;
  //         } else if (oldBool != newBool) {
  //           allSame = false;
  //           break;
  //         } else {
  //           allSame = true;
  //         }
  //     }
  //     if (!allSame) {
  //       // Iterate over venue list to find non matching venues
  //       // for(int i = 0; i < venues.length; i++) {
  //       //   for (MapEntry<String, bool> each in buttonStates.entries) {
  //       //     if (each.value == false) {
  //       //       venues.removeAllVenuesByType(each.key);
  //       //     }
  //       //   }
  //       // }

  //       List<int> indexesToRemove;
  //       for (MapEntry<String, bool> each in buttonStates.entries) {
  //         // Check if index already in list
  //         if(indexesToRemove != null){
  //           for(List<int> exisitingIndex in indexesToRemove){

  //           }
  //         }

  //         if(indexesToRemove.c)
  //         venues.listOfIndexWithMatchingFilter(each.value);
  //       }

  //       }

  // }
  bool isAllFiltersSame() {
    // Check if all value arr same. If true return full venue list
    bool oldBool;
    bool allSame;
    for (MapEntry<String, bool> each in buttonStates.entries) {
      bool newBool = each.value;
      if (oldBool == null) {
        oldBool = each.value;
      } else if (oldBool != newBool) {
        allSame = false;
        break;
      } else {
        allSame = true;
      }
    }
    return allSame;
  }

  // void _numOfVenuesWFilter() {
  //   numOfVenuesWFilter = 0;
  //   if (!isAllFiltersSame()) {
  //     for (int i = 0; i < venues.length; i++) {
  //       for (MapEntry<String, bool> each in buttonStates.entries) {
  //         // print(each.key);
  //         if (each.value == true) {
  //           if (venues[i].venueType.contains(each.key)) {
  //             // count number of matches in filter criteria
  //             // print(venueTypesTemp);
  //             numOfVenuesWFilter += 1;
  //           }
  //         }
  //       }
  //     }
  //   } else {
  //     numOfVenuesWFilter = numOfVenues;
  //   }
  //   print('New number of benues: ' + numOfVenuesWFilter.toString());
  // }

  Widget _venueListBuilder(
      BuildContext context, int index, Animation<double> animation) {
    if (numOfVenues > 0) {
      while (index < numOfVenues) {
        // print("Index: "+index.toString());
        // print("Length of venues: "+numOfVenues.toString());
        // print('building venue list');
        // print("Extra Venue: "+venues[11].venueName);
        // print(buttonStates);
        VenueModel venue = venues[index];
        List venueTypesTemp = venue.venueType;

        Widget listContainer() {
          return SlideTransition(
            position: venueListAnimation,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: VenueItemCard(
                context: context,
                venueData: venue,
              ),
            ),
          );
        }
        // return listContainer();

        // If a filter is selected. Only return items matching criteria
        if (!isAllFiltersSame()) {
          for (MapEntry<String, bool> each in buttonStates.entries) {
            // print(each.key);
            if (each.value == true) {
              if (venueTypesTemp.contains(each.key)) {
                // count number of matches in filter criteria
                // print(venueTypesTemp);
                return listContainer();
              } else {
                return SizedBox();
              }
            }
          }
        } else {
          // If no filters are slected return whole list
          return listContainer();
        }
      }
    } else {
      return Container(child: Text('No Venues'));
    }

    // return Card(child: Text(index.toString()));
  }

  Widget debugTouch(child) {
    return GestureDetector(
        onTap: () {
          print('touch');
        },
        child: child);
  }

  bool isTransitioning() {
    bool val = false;
    if (!isVenueFilterOn) {
      if (!venueListAnimation.isCompleted) {
        print('Is transitioning to hgide');
        val = true;
      }
    }
    print('val is: ' + val.toString());
    return val;
  }

  Widget futureListView(context) {
    return FutureBuilder<Map>(
        future: _searchRegionDataFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            upcoming =
                GigsList.fromJson(snapshot.data['upcoming_events']['gig_list']);
            // venues = VenueList.fromJson(snapshot.data['venue_list']);
            meta = snapshot.data['upcoming_events']['meta'];
            return SliverToBoxAdapter(
              child: Column(
                children: [
                  filterButtons(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        Container(
                          child: (isGigListViewOn)
                              ? AnimatedList(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  initialItemCount: numOfTimeSlots,
                                  itemBuilder: _gigListBuilder,
                                )
                              : SizedBox(),
                        ),

                        /// * Because venue list is also being drawn but pushed to the right of
                        /// gig list, it covers the venue list, blocking pointers. When on gig list,
                        /// ignore pointer on the venue list container.
                        IgnorePointer(
                          ignoring: !isVenueFilterOn,
                          child: (isVenueViewOn)
                              ? Column(
                                  children: [
                                    SizeTransition(
                                      sizeFactor: filterAnimation,
                                      axis: Axis.vertical,
                                      axisAlignment: 1,
                                      child: Align(
                                        heightFactor: (firstLoad) ? 0 : null,
                                        child: moreFilterButtons(),
                                      ),
                                    ),
                                    AnimatedList(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      initialItemCount:
                                          numOfVenues, //venues.venues.length,
                                      itemBuilder: _venueListBuilder,
                                    ),
                                  ],
                                )
                              : SizedBox(),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          } else {
            return centerSliverProgressIndicator(context);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: (searchRegionData == null) ? Size.fromHeight(80) : Size.fromHeight(0),
      //   child: (searchRegionData == null) ? DefaultAppBar() : SizedBox(),
      // ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: CustomScrollView(
          physics: globalScrollPhysics(),
          slivers: [
            AppBarRegSearch(location: widget.regionName),
            futureListView(context),
          ],
        ),
      ),
    );
  }

  // return Scaffold(
  //     appBar: PreferredSize(
  //       preferredSize: Size.fromHeight(80),
  //       child: InfoPageAppBar(),
  //     ),
  //     body: Container(
  //       color: Theme.of(context).backgroundColor,
  //       child: FutureBuilder(
  //         future: _artistInfoFuture,
  //         builder: (context, snapshot) {
  //           if (snapshot.hasData) {
  //             final artistInfo = snapshot.data;
  //             return artistInfoCont(context, artistInfo);
  //           } else {
  //             return CircularProgressIndicator();
  //           }
  //         },
  //       ),
  //     ),
  //   );

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

  /// TODO Deprectae and replace with FilterChip
  /// This was without knowing FilterChip existed
  Widget filterButton(text, isPressed) {
    ButtonStyle buttonSyle = ButtonStyle(
      elevation: MaterialStateProperty.all<double>(isPressed ? 10 : 0.1),
      minimumSize: MaterialStateProperty.all<Size>(Size(100, 50)),
      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(5)),
      backgroundColor: MaterialStateProperty.all<Color>(
          isPressed ? Theme.of(context).accentColor : Colors.transparent),
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
      onPressed: () {
        if (text == 'Gigs' && isPressed == false) {
          gigListAnimationController.reverse();
          venueListAnimationController.reverse();
          filterAnimationController.reverse();

          setState(() {
            isVenueFilterOn = !isVenueFilterOn;
            isGigListViewOn = true;
          });
        } else if (text == 'Venues' && isPressed == false) {
          gigListAnimationController.forward();
          venueListAnimationController.forward();
          filterAnimationController.forward();
          firstLoad = false;
          setState(() {
            isVenueFilterOn = !isVenueFilterOn;
            isVenueViewOn = true;
            // isGigListViewOn = false;
          });
        }
      },
      style: buttonSyle,
    );
  }

  Widget extraFilterButton(text, buttonState) {
    // Color textColour = Theme.of(context).primaryColor;

    ButtonStyle buttonSyle = ButtonStyle(
        elevation: MaterialStateProperty.all<double>(buttonState ? 5 : 0.1),
        minimumSize: MaterialStateProperty.all<Size>(Size(80, 25)),
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
        backgroundColor: MaterialStateProperty.all<Color>(
            buttonState ? hexToColor('#962e11') : Colors.transparent),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.0),
          ),
        ),
        textStyle: MaterialStateProperty.all<TextStyle>(
          TextStyle(fontSize: 15, fontFamily: 'Staatliches'),
        ),
        side: MaterialStateProperty.all<BorderSide>(
          BorderSide(
              color: buttonState ? hexToColor('#962e11') : Colors.transparent,
              width: 2),
        ));

    // if (!buttonState) {
    //   elevation = 0;
    // } else {
    //   textColour = Colors.white10;
    // }

    return OutlinedButton(
      // highlightElevation: elevation,
      child: Text(text,
          style: TextStyle(color: buttonState ? Colors.white : Colors.black54)),
      onPressed: () {
        setState(() {
          buttonStates[text] = !buttonStates[text];
          // _numOfVenuesWFilter();

          // _removeVenueItems();
        });
      },
      // borderSide: BorderSide(color: Theme.of(context).accentColor),
      style: buttonSyle,
      // highlightedBorderColor: Theme.of(context).accentColor,
    );
  }

  Widget filterButtons() {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: ButtonBar(alignment: MainAxisAlignment.spaceEvenly, children: [
        filterButton('Gigs', !isVenueFilterOn),
        filterButton('Venues', isVenueFilterOn)
      ]),
    );
  }

  Widget searchRegionResCont(context, searchRegionData) {
    GigsList upcoming = GigsList.fromJson(searchRegionData['upcoming_events']);

    double headingSize = 25;
    double headingWidth = 80;

    int maxLines = 10;
    return Container(
      height: 50,
      child: filterButtons(),
    );
  }
}
