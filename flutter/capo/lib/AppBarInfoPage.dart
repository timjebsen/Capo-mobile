import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'funcs.dart';
import 'SearchView.dart';
import 'funcs.dart';

class AppBarInfoPage extends StatefulWidget {
  const AppBarInfoPage({
    Key key,
    @required this.text,
    //@required this.context,
  }) : super(key: key);

  final String text;
  // final BuildContext context;

  @override
  _AppBarRegSearchState createState() => _AppBarRegSearchState();
}

class _AppBarRegSearchState extends State<AppBarInfoPage> {
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
          onPressed: () => {},
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
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Discover ',
                          style: TextStyle(
                            fontFamily: 'Staatliches',
                            fontSize: 30,
                            color: hexToColor('#c7c7c7'),
                          ),
                        ),
                      ),
                      Flexible(
                        // width: 250,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            ' ${widget.text} ',
                            style: TextStyle(
                              fontFamily: 'Staatliches',
                              fontSize: 30,
                              color: Theme.of(context).accentColor,
                              
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                      // TextSpan(
                      //   text: widget.numOfGigs.toString(),
                      //   style: TextStyle(
                      //     fontFamily: 'Staatliches',
                      //     fontSize: 40,
                      //     color: Theme.of(context).accentColor,
                      //   ),
                      // ),
                      // TextSpan(
                      //   text: " Gigs",
                      //   style: TextStyle(
                      //     fontFamily: 'Staatliches',
                      //     fontSize: 40,
                      //     color: Theme.of(context).accentColor,
                      //   ),
                      // ),
                    ],
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
