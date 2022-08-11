import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget {
  const DefaultAppBar({
    Key key,
  }) : super(key: key);

  final double myAppBarHeight = 50;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: myAppBarHeight,
      //bottom: PreferredSize(preferredSize: Size.fromHeight(50.0), child: Text('')),
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
                  width: 50,
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
          onPressed: null,
          // widget.context.searchView(),
        ),
      ],
      // flexibleSpace: FlexibleSpaceBar(
      //   collapseMode: CollapseMode.pin,
      //   background: Column(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: <Widget>[
      //       Container(
      //         margin: EdgeInsets.symmetric(horizontal: 20),
      //         alignment: Alignment(-1.0, 0),
      //         height: 55,
      //         child: Column(
      //           children: <Widget>[
      //             Row(
      //               children: <Widget>[
      //                 Text(
      //                   "Test",
      //                   // Jiffy(DateTime.now()).format('E, do MMM').toString(),
      //                   // style: TextStyle(
      //                   //   fontFamily: 'Archivo',
      //                   //   fontStyle: FontStyle.italic,
      //                   //   fontSize: 15,
      //                   //   height: 0,
      //                   //   color: hexToColor('#E9E9E9'),
      //                   // ),
      //                   textAlign: TextAlign.left,
      //                 ),
      //               ],
      //             ),
      //             // Row(
      //             //   children: <Widget>[
      //             //     Text.rich(
      //             //       TextSpan(
      //             //         children: <TextSpan>[
      //             //           TextSpan(
      //             //             text: 'This Week',
      //             //             style: TextStyle(
      //             //               fontFamily: 'Staatliches',
      //             //               fontSize: 38,
      //             //               color: Theme.of(context).accentColor,
      //             //             ),
      //             //           ),
      //             //           TextSpan(
      //             //             text: ' in ${widget.location}: ',
      //             //             style: TextStyle(
      //             //               fontFamily: 'Staatliches',
      //             //               fontSize: 28,
      //             //               color: hexToColor('#E9E9E9'),
      //             //             ),
      //             //           ),
      //             //           TextSpan(
      //             //             text: widget.numOfGigs.toString(),
      //             //             style: TextStyle(
      //             //               fontFamily: 'Staatliches',
      //             //               fontSize: 38,
      //             //               color: Theme.of(context).accentColor,
      //             //             ),
      //             //           ),
      //             //           TextSpan(
      //             //             text: " Gigs",
      //             //             style: TextStyle(
      //             //               fontFamily: 'Staatliches',
      //             //               fontSize: 38,
      //             //               color: Theme.of(context).accentColor,
      //             //             ),
      //             //           ),
      //             //         ],
      //             //       ),
      //             //     ),
      //             //   ],
      //             // ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      //   centerTitle: true,
      // ),
    );
  }
}
