import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'funcs.dart';
import 'SearchView.dart';
import 'funcs.dart';

class AppBarLoc extends StatefulWidget {
  const AppBarLoc({
    Key key,
    @required this.numOfGigs,
    @required this.forecast,
    @required this.location,
    @required this.t,
    @required this.setState,
    //@required this.context,
  }) : super(key: key);

  final int numOfGigs;
  final String location;
  final SearchView t;
  final Function setState;
  final String forecast;
  // final BuildContext context;

  @override
  _AppBarLocState createState() => _AppBarLocState();
}

class _AppBarLocState extends State<AppBarLoc> {
  // void searchView() {
  //   print('object');
  //   setState(() {
  //     widget.t.changeView();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: 80,
      //bottom: PreferredSize(preferredSize: Size.fromHeight(50.0), child: Text('')),
      floating: false,
      forceElevated: true,
      //elevation: 5,
      expandedHeight: 150,
      pinned: true,
      snap: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                // color: Colors.blue,
                child: Image(
                  image: AssetImage('assets/img/logo_full.png'),
                  width: 70,
                ),
              )
            ],
          )
        ],
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).primaryColor,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search, color: Colors.grey[100]),
          onPressed: widget.setState,
          // widget.context.searchView(),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment(-1.0, 0),
              height: 55,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        Jiffy(DateTime.now()).format('E, do MMM').toString(),
                        style: TextStyle(
                          fontFamily: 'Archivo',
                          fontStyle: FontStyle.italic,
                          fontSize: 15,
                          height: 0,
                          color: hexToColor('#E9E9E9'),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Container(
                      child: FittedBox(
                        child: Row(
                          children: <Widget>[
                            Text.rich(
                              TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: widget.forecast,
                                    style: TextStyle(
                                      fontFamily: 'Staatliches',
                                      fontSize: 40,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' in ${widget.location}: ',
                                    style: TextStyle(
                                      fontFamily: 'Staatliches',
                                      fontSize: 30,
                                      color: hexToColor('#E9E9E9'),
                                    ),
                                  ),
                                  TextSpan(
                                    text: widget.numOfGigs.toString(),
                                    style: TextStyle(
                                      fontFamily: 'Staatliches',
                                      fontSize: 40,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " Gigs",
                                    style: TextStyle(
                                      fontFamily: 'Staatliches',
                                      fontSize: 40,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
    );
  }
}
