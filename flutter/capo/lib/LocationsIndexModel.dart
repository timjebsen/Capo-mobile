import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationsIndex {
  final List<Map<String, dynamic>> indexList;

  LocationsIndex({
    this.indexList,
  });

  factory LocationsIndex.fromJson(List<dynamic> parsedJson) {
    List<Map<String, dynamic>> indexList = List<Map<String, dynamic>>();
    // print(parsedJson[0]['dbid']);
    for (var i = 0; i < parsedJson.length; i++) {
      String uuid = parsedJson[i]['uuid'];
      int events = parsedJson[i]['events'];
      String name = parsedJson[i]['name'];
      List<dynamic> venueTypes = parsedJson[i]['venue_type'];
      double lat = parsedJson[i]['coords']['lat'];
      double lng = parsedJson[i]['coords']['lng'];
      // print("Venue: " +
      //     name +
      //     " lat: " +
      //     lat.toString() +
      //     " lng: " +
      //     lng.toString());
      LatLng coords = LatLng(lat, lng);
      // print(coords.toString());
      if (coords != null) {
        Map<String, dynamic> item = {
          'id': uuid,
          'events': events,
          'name': name,
          'venueTypes': venueTypes,
          'coords': coords,
        };

        indexList.add(item);
      }
    }
    return LocationsIndex(
      indexList: indexList,
    );
  }
  operator [](index) => indexList[index];
}
