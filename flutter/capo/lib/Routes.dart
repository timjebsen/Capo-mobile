import 'package:flutter/material.dart';
import 'package:capo/SearchRegionPage.dart';
import 'main.dart';
import 'RestOfWeekPage.dart';
import 'ArtistInfoPage.dart';
import 'VenueInfoPage.dart';
import 'SearchRegionPage.dart';
import 'MapPage.dart';

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // if (settings.isInitialRoute)
    //   return child;
    // Fades between routes. (If you don't want any animation,
    // just return child.)
    return new FadeTransition(opacity: animation, child: child);
  }
}

void homePage(context) {
  Navigator.push(context, MyCustomRoute(builder: (context) => Home()));
}

void restOfWeekPage(context) {
  Navigator.push(
      context, MyCustomRoute(builder: (context) => RestOfWeekPage()));
}

void artistPage(context, String artistId, String artistName) {
  Navigator.push(
      context, MyCustomRoute(builder: (context) => ArtistInfoPage(artistId: artistId, artistName: artistName)));
}

void venuePage(context, String venueId) {
  Navigator.push(
      context, MyCustomRoute(builder: (context) => VenueInfoPage(venueId: venueId)));
}

void searchRegionPage(context, String regionId, String regionName) {
  Navigator.push(
      context, MyCustomRoute(builder: (context) => SearchRegionPage(regionId: regionId, regionName: regionName)));
}

void mapPage(context) {
  Navigator.push(
      context, MyCustomRoute(builder: (context) => MapPage()));
}