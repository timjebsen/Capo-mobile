import 'package:capo/VenueModel.dart';
import 'package:intl/intl.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'GigItem.dart';
import 'package:http/http.dart' as http;
import 'SearchIndexModel.dart';
import 'LocationsIndexModel.dart';
import 'dart:convert';
import 'GigModel.dart';
import 'Styles.dart';

String formatGroupTitle(groupMode, unformattedHeader) {
  // Group by time, raw header = "####""
  String formattedTitle;
  if (groupMode == 0) {
    var timeSlotColon =
        StringUtils.addCharAtPosition(unformattedHeader, ":", 2);
    formattedTitle =
        new DateFormat.jm().format(DateFormat.Hm().parse(timeSlotColon));
    return formattedTitle;
  } else if (groupMode == 1) {
    formattedTitle = new DateFormat("EEEE d")
        .format(DateFormat("yyyy-MM-dd").parse(unformattedHeader));
    return formattedTitle;
  } else {
    return "Error formatting header";
  }
}

Widget noGigsMsg(location) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Container(
      child: Text(
        "Bummer! No gigs today.\nHere's whats coming up in $location",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, color: Colors.black54),
      ),
    ),
  );
}

ScrollPhysics globalScrollPhysics() {
  return BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
}

Widget gigItemContainer(context, gigIndData, groupMode) {
  return GigItemCard(
      context: context, gigItemData: gigIndData, groupMode: groupMode);
}

Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

Widget centerSliverProgressIndicator(context) {
  return SliverToBoxAdapter(
      child: Container(
    // Set height to screen hight - app bar height
    height: MediaQuery.of(context).size.height - (80 + 150),
    child: Align(
      child: CircularProgressIndicator(),
    ),
  ));
}

Widget centerProgressIndicator(context) {
  return Container(
    // Set height to screen hight - app bar height
    height: MediaQuery.of(context).size.height - (80 + 150),
    child: Align(
      child: CircularProgressIndicator(),
    ),
  );
}

// Used in venueinfopage/artistgenre to print list of text with formatting
String venueTypesToString(List typeList){
  String venueTypeString = '';
    if (typeList.length < 1) {
      venueTypeString = ' ';
    } else {
      for (int i = 0; i < typeList.length; i++) {
        if (i < typeList.length - 1) {
          venueTypeString += typeList[i].toString() + ", ";
        } else {
          venueTypeString += typeList[i].toString();
        }
      }
    }
  return venueTypeString;
}

// Used in venueinfopage to print opening hours
List<Widget> listToText(List list, TextStyle style){
    List<Widget> widgetArray = [];
    if (list != null){
      for(String each in list){
        widgetArray.add(Text(each, style: style));
      }
    }
     return widgetArray;
  }

// * API Calls ------------------------------------------------
// TODO Re-factor get functions
// TODO Handle timout and bad responses
// String base = "http://192.168.1.69:12122";
// String api_v = "/v0.1/";
// String base = "http://localhost:12122";
String base = "http://api.capo.guide";
String url;
String call;

Future<SearchIndex> getSearchIndex() async {
  call = '/index/search';
  url = base + call;
  final res = await http.get(url);
  if (res.statusCode == 200) {
    final jsonIndex = jsonDecode(res.body);
    print('Index received');
    return SearchIndex.fromJson(jsonIndex);
  } else {
    print('Error retrieving data: index data');
    // throw Exception();
  }
}

Future<Map<String, dynamic>> getGigs(int query) async {
  if (query == 0) {
    // ! using an old resource v0.1
    // TODO refactor to v0.2 
    call = '/events?day=today';
    url = base + call;
  } else if (query == 1) {
    call = '/events/month';
    url = base + call;
  }

  final res = await http.get(url);

  if (res.statusCode == 200) {
    final jsonGig = jsonDecode(res.body);
    print('Data received: getGigs');

    Map<String, dynamic> data = Map<String, dynamic>();
    GigsList gigs = GigsList.fromJson(jsonGig["events"]);
    GigListMeta meta = GigListMeta.fromJson(jsonGig["meta"]);
    data['meta'] = meta;
    data['events'] = gigs;
    return data;
  } else {
    print('Error retrieving data: getGigs');
    // throw Exception();
  }
}

Future<Map<String, dynamic>> getArtistInfo(String id) async {
  Map<String, dynamic> info = Map<String, dynamic>();
  call = '/artist/info?id=' + id;
  url = base + call;
  print('Getting Artist info on: ' + id);
  final res = await http.get(url);
  if (res.statusCode == 200) {
    final jsonInfo = jsonDecode(res.body);
    info = jsonInfo;
    print('Data received: Artist Info on id: ' + id);
    return info;
  } else {
    print('Error retrieving Artist info dat on id: ' + id);
    // throw Exception();
  }
}

// * Returns a future map containing venue data, and gigs associated. S
// * Should this be 2 seperate get functions?... prbably
Future<Map<String, dynamic>> getVenueInfo(String id) async {
  Map<String, dynamic> data = Map<String, dynamic>();
  call = '/venue/info?id=' + id;
  url = base + call;
  print('Getting Venue info on: ' + id);
  final res = await http.get(url);
  if (res.statusCode == 200) {
    final jsonInfo = jsonDecode(res.body);
    // GigsList upcomingGigs = GigsList.fromJson(jsonInfo[""])
    VenueModel venue = VenueModel.fromMap(jsonInfo['venue_info']);
    GigsList gigs = GigsList.fromJson(jsonInfo["upcoming_events"]["gig_list"]);
    data['venueInfo'] = venue;
    data['upcoming'] = gigs;
    print('Data received: Venue Info: id: ' + id);
    return data;
  } else {
    print('Error retrieving Venue Info data on id: ' + id);
    // throw Exception();
  }
}

// Future<GigsList> getUpcomingGigs(String id) async {
//   Map<String, dynamic> info = Map<String, dynamic>();
//   GigsList gigList;
//   call = '/artistInfo?id=' + id;
//   url = base + call;
//   print('Getting Artist info on: ' + id);
//   final res = await http.get(url);
//   if (res.statusCode == 200) {
//     final jsonInfo = jsonDecode(res.body);
//     info = jsonInfo;
//     print('Data received: Artist Info on id: ' + id);
//     return gigList;
//   } else {
//     print('Error retrieving Artist info dat on id: ' + id);
//     // throw Exception();
//   }
// }

Future<Map<String, dynamic>> getSearchRegion(String id) async {
  Map<String, dynamic> info = Map<String, dynamic>();
  call = '/search/region?id=' + id;

  url = base + call;
  final res = await http.get(url);
  print('Getting /searchRegion?id= search data on: ' + id);
  if (res.statusCode == 200) {
    final jsonInfo = jsonDecode(res.body);
    info = jsonInfo;
    print('Data received: region seach data: id: ' + id);

    return info;
  } else {
    print('her3');
    print('Error retrieving region seach data on id: ' + id);
    // throw Exception();
  }
}

Future<LocationsIndex> getLocationsIndex() async {
  call = '/index/venue/locations';
  url = base + call;
  final res = await http.get(url);
  if (res.statusCode == 200) {
    final jsonIndex = jsonDecode(res.body);
    print('locsIndex received');
    return LocationsIndex.fromJson(jsonIndex);
  } else {
    print('Error retrieving data: locsIndex data');
    // throw Exception();
  }
}

// Future<LocationsIndex> getImages(String uuid) async {
//   call = '/locsIndex';
//   url = base + call;
//   final res = await http.get(url);
//   if (res.statusCode == 200) {
//     final jsonIndex = jsonDecode(res.body);
//     print('locsIndex received');
//     return LocationsIndex.fromJson(jsonIndex);
//   } else {
//     print('Error retrieving data: locsIndex data');
//     // throw Exception();
//   }
// }


// * Buttons ----------------------------------------------------------
// TODO Merge and make a global function for buildButtonArray from searchRegionPage
List buildButtonArray(context, Map socials) {
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
          buttonList.add(socialsButton(context, buttonText, each.value));
        }
      }
    }
  }
  return buttonList;
}

Widget socialButtonsContainer(context, Map socialsMap) {
  ButtonBar socialsButtonBar = ButtonBar(
    buttonPadding: EdgeInsets.all(0.0),
    alignment: MainAxisAlignment.spaceEvenly,
    children: buildButtonArray(context, socialsMap),
  );
  return Container(child: socialsButtonBar);
}

Widget socialsButton(context, text, value) {
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

  