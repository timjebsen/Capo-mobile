import 'package:flutter/material.dart';
import 'package:capo/RestOfWeekPage.dart';
import 'funcs.dart';
import 'Routes.dart';
import 'main.dart';

class GigListContainer extends StatefulWidget {
  const GigListContainer({
    Key key,
    @required this.context,
    @required this.index,
    @required this.gigs,
    @required this.headerTitleKey,
    @required this.headerTitleFormatted,
    @required this.numOfGigs,
    @required this.groupMode,
    @required this.vis,
    @required this.refPage,
  }) : super(key: key);

  final BuildContext context;
  final int index;
  final dynamic gigs;
  final String headerTitleKey;
  final String headerTitleFormatted;
  final int numOfGigs;
  final int groupMode;
  final bool vis;
  final int refPage;

  @override
  _GigListContainerState createState() => _GigListContainerState();
}

class _GigListContainerState extends State<GigListContainer>
    with AutomaticKeepAliveClientMixin {
  bool finishedAnim = false;

  
  /// A gig list is broken into sections, such as all gigs on x day, or on x time slot.
  /// The section category and its header titles is defined by the API. See gigList data struc
  /// 
  /// Animated opacity is used to hide the gig list in the main page. Will be deprecated
  /// in future.
  /// 
  /// GigList must be inside a build function that iterates over each section.
  /// This should be renamed gig list section container.
  /// 
  /// Finally a list generated from the gigs in the given section.
  /// A gigItemContainer is given the section object
  /// to get the relevant List of gigs.
  /// 
  /// TODO Refactor this function to require only the gigList object
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
        opacity: (widget.vis) ? 1.0 : 0.0,
        onEnd: () => finishedAnim = true,
        duration: Duration(milliseconds: 500),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: (widget.vis == false && finishedAnim == true)
              ? SizedBox()
              : Column(
                  children: <Widget>[
                    (widget.index < 1 && widget.refPage == 0)
                        ? noGigsMsg("Brisbane")
                        : SizedBox(),
                    Container(
                      // color: Colors.black.withOpacity(0.3),
                      decoration: BoxDecoration(
                        color: hexToColor('#666666'),//Colors.black87.withOpacity(0.6),
                      //   border: Border(
                      //       // left: BorderSide(color: Colors.black54, width: 3)),
                      //   //borderRadius: BorderRadius.only(topLeft: Radius.circular(40)),
                      // ),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      //color: Colors.lime,
                      child: Padding(
                        padding: EdgeInsets.only(left : 6.0, right: 6.0, bottom: 9.0),
                        child: Column(
                          children: <Widget>[
                            // Timeslot heading
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Container(
                                // color: Colors.blue,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.headerTitleFormatted,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 27,
                                    color: hexToColor('#ffffff'),// Theme.of(context).accentColor,
                                    shadows: <Shadow>[
                                      Shadow(
                                        blurRadius: 8.0,
                                        offset: Offset(2, 3),
                                        color: Color.fromARGB(0, 0, 0, 0),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Gig list outer container
                            Container(
                              //width: 350,
                              child: Column(
                                children: List.generate(
                                    widget.gigs.gigs[widget.headerTitleKey]
                                        .length, (int k) {

                                  return gigItemContainer(context,
                                      widget.gigs.gigs[widget.headerTitleKey]
                                          [k],
                                      widget.groupMode);
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                  ],
                ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
