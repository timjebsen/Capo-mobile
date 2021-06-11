import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'main.dart';
import 'Routes.dart';
import 'RestOfWeekPage.dart';


class DefaultDrawer extends StatelessWidget {
  const DefaultDrawer({
    Key key,
    @required this.context,
  }) : super(key: key);

  final BuildContext context;

  void nothing() {}

  Widget drawerListItem(text, function) {
    return Container(
      // decoration: BoxDecoration(
      //   border: Border(
      //     top: BorderSide(color: Colors.white38, width: 0.5),
      //     //bottom: BorderSide(color: Colors.white38, width: 0.5),
      //   ),
      // ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 32),
        dense: true,
        // leading: Icon(
        //   Icons.audiotrack,
        //   color: Colors.white,
        // ),
        title: RichText(
          text: TextSpan(
            text: text,
            style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Archivo'),
          ),
        ),
        enabled: true,
        onTap: function,
      ),
    );
  }

  Widget drawListHeader(text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
      child: Container(
        child: RichText(
          text: TextSpan(
            text: text,
            style: TextStyle(
                fontSize: 30,
                fontFamily: 'Staatliches',
                color: Theme.of(context).accentColor),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black87,
        child: ListView(
          children: <Widget>[
            Container(
              height: 100,
              child: DrawerHeader(
                child: Container(
                  // height: 50,
                  //color: Colors.blue,
                  child: Image(
                    image: AssetImage('assets/img/logo_full_2.png'),
                  ),
                ),
              ),
            ),
            drawListHeader("Gigs"),
            drawerListItem("Today", () => homePage(context)),
            drawerListItem("This Weekend", () => restOfWeekPage(context)),
            drawerListItem("Calendar", nothing),
            drawListHeader("Venues"),
            drawerListItem("Open Map", () => mapPage(context)),
            drawerListItem("Search", () => mapPage(context)),

            

            AboutListTile()
          ],
        ),
      ),
    );
  }
}
