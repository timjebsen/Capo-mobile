import 'package:flutter/material.dart';
import 'package:capo/DefaultAppBar.dart';
import 'AppBarInfoPage.dart';
import 'funcs.dart';
import 'LocationsIndexModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'Routes.dart';

class MapPage extends StatefulWidget {
  const MapPage({
    Key key,
    // @required this.context,
    // @required this.venueName,
    //@required this.venueId,
  }) : super(key: key);

  // final String venueId;
  // final String venueName;

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Future<LocationsIndex> _locationIndexFuture;
  LocationsIndex locsIndex;
  String _mapStyle;
  GoogleMapController mapController;
  double filterContHeight = 80;

  void loadData() {
    setState(() {
      _locationIndexFuture = getLocationsIndex();
      _locationIndexFuture.then((r) {
        locsIndex = r;
        buildTypeList();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
    rootBundle.loadString('assets/gmap/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageCont(),
    );
  }

  Widget pageCont() {
    return Container(
        color: Theme.of(context).backgroundColor,
        child: CustomScrollView(
          // shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          slivers: [
            // AppBarInfoPage(text: 'venues near you'),
            // Filter Buttons
            SliverToBoxAdapter(child: DefaultAppBar()),
            mapCont(context, centreOfMap, locsIndex)
          ],
        ));
  }

  Widget filterCont() {
    return Container(
      height: filterContHeight,
      child: filterButtons(),
    );
  }

  Widget filterButtons() {
    return PhysicalModel(
      elevation: 10,
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          // color: Colors.amberAccent,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Container(
              //   // color: Colors.amberAccent,
              //   child: Text(
              //     'Venue Type',
              //     style: TextStyle(fontSize: 15, fontFamily: 'Staatliches'),
              //   ),
              // ),
              Expanded(
                child: Container(
                  // color: Colors.amberAccent,

                  child: ListView(
                    physics: AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics()),
                    // shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    // alignment: WrapAlignment.spaceEvenly,
                    // spacing: 40.0,
                    children: buildFilterArray(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List venueTypes = [];
  Map<String, bool> buttonStates = {};
  void buildTypeList() {
    for (Map eachEntry in locsIndex.indexList) {
      for (String type in eachEntry['venueTypes']) {
        if (!venueTypes.contains(type)) {
          if (type == 'Locality') {
          } else {
            venueTypes.add(type);
          }
        }
      }
    }

    buttonStates = {};
    for (int i = 0; i < venueTypes.length; i++) {
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

  Widget extraFilterButton(text, buttonState) {
    // Color textColour = Theme.of(context).primaryColor;

    ButtonStyle buttonSyle = ButtonStyle(
        elevation: MaterialStateProperty.all<double>(buttonState ? 5 : 0.1),

        // minimumSize: MaterialStateProperty.all<Size>(Size(80, 25)),
        // padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
        backgroundColor: MaterialStateProperty.all<Color>(
            buttonState ? hexToColor('#962e11') : Colors.white12),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.0),
          ),
        ),
        textStyle: MaterialStateProperty.all<TextStyle>(
          TextStyle(
            fontSize: 15,
            fontFamily: 'Staatliches',
          ),
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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlinedButton(
        // highlightElevation: elevation,
        child: Text(text,
            style:
                TextStyle(color: buttonState ? Colors.white : Colors.white54)),
        onPressed: () {
          setState(() {
            buttonStates[text] = !buttonStates[text];
            buildMarkers(locsIndex);
            // _numOfVenuesWFilter();

            // _removeVenueItems();
          });
        },
        // borderSide: BorderSide(color: Theme.of(context).accentColor),
        style: buttonSyle,
        // highlightedBorderColor: Theme.of(context).accentColor,
      ),
    );
  }

  // Seperate page to display while loading. Mostly used to draw appbar while data is retrieved
  // Widget pageLoading() {
  //   return Container(
  //     color: Theme.of(context).backgroundColor,
  //     child: CustomScrollView(
  //       slivers: [
  //         AppBarInfoPage(text: widget.venueName),
  //         centerSliverProgressIndicator(context),
  //       ],
  //     ),
  //   );
  //
  // * Temp values
  // Map<int, dynamic> listOfLocs = {
  //   0: {
  //     "coords": {"lat": 123, "lng": 123},
  //     "name": "place name",
  //     "type": "venue or gig",
  //     "id": "place uuid"
  //   }
  // };
  Map<String, Marker> _markers = {};

  // Marker locsIndexToMarkers(locsIndex) {}

  List centreOfMap = [123, 123];

  bool isTrueInFilter(objectTypesList, buttonStates) {
    // Iterate over each type in the types list and check if button state contains
    for (String objectType in objectTypesList) {
      // Iterate over buttonstates keys
      for (String typeToCheckAgainst in buttonStates.keys) {
        // Check if key matches type
        if (typeToCheckAgainst == objectType) {
          // Return true if typeToCheckAgainst.value is true
          if (buttonStates[typeToCheckAgainst] == true) {
            return true;
          }
        }
      }
    }
    return false;
  }

  BitmapDescriptor venueIconDef;
  BitmapDescriptor venueIconHL;

  void buildMarkers(locsIndex) {
    _markers = {};
    for (Map<String, dynamic> each in locsIndex.indexList) {
      // print(isTrueInFilter(each['venueTypes'], buttonStates));
      if (each['coords'] != null &&
          isTrueInFilter(each['venueTypes'], buttonStates)) {
        final marker = Marker(
          markerId: MarkerId(each['name']),
          position: each['coords'],
          icon: (each['events'] > 0) ? venueIconHL : venueIconDef,
          // icon: (each['events'] > 0) ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange) : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: InfoWindow(
            title: each['name'],
            snippet: "Press for more info",
            onTap: () {
              venuePage(context, (each['id']));
            },

            // snippet: office.address,
          ),
        );

        _markers[each['name']] = marker;
      }
    }
    print(_markers.toString());
    setState(() {});
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    mapController.setMapStyle(_mapStyle);
    ImageConfiguration configuration = createLocalImageConfiguration(context);
    BitmapDescriptor.fromAssetImage(
            configuration, 'assets/img/gmap/markers/bar_def.png')
        .then((icon) {
      setState(() {
        venueIconDef = icon;
      });
    });
    BitmapDescriptor.fromAssetImage(
            configuration, 'assets/img/gmap/markers/bar_hl.png')
        .then((icon) {
      setState(() {
        venueIconHL = icon;
      });
    });

    locsIndex = await getLocationsIndex();
    setState(() {
      _markers.clear();
      buildMarkers(locsIndex);
    });
  }

  Widget mapCont(
      BuildContext context, List centerLoc, LocationsIndex locsIndex) {
    return FutureBuilder<LocationsIndex>(
      future: _locationIndexFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SliverToBoxAdapter(
            child: Column(
              children: [
                // filterCont(),
                Stack(children: [
                  Container(
                    height: MediaQuery.of(context).size.height -
                        (filterContHeight + 70),
                    child: GoogleMap(
                      tiltGesturesEnabled: false,
                      buildingsEnabled: false,
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(-26.8048559, 153.1335567),
                        zoom: 8,
                      ),
                      markers: _markers.values.toSet(),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        // height: 100,
                        // width: 100,
                        // color: Colors.white.withAlpha(50),
                        
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(children: [
                              Image(
                                  image: AssetImage(
                                      'assets/img/gmap/markers/bar_hl.png'),
                                  height: 30),
                              Text(
                                ' - Live Music Today',
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              )
                            ]),
                          ),
                          Row()
                        ]),
                      ),
                    ),
                  ),
                ]),filterCont(),
              ],
            ),
          );
        } else {
          return centerSliverProgressIndicator(context);
        }
      },
    );
  }
}
