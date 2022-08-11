import 'package:flutter/material.dart';
import 'package:capo/SearchIndexModel.dart';
import 'GigModel.dart';
import 'GigModel.dart';
import 'GigListCont.dart';
import 'funcs.dart';
import 'Drawer.dart';
import 'SearchPage.dart';
import 'SearchView.dart';
import 'RowAppBar.dart';

class RestOfWeekPage extends StatefulWidget {
  @override
  _RestOfWeekState createState() => _RestOfWeekState();
}

class _RestOfWeekState extends State<RestOfWeekPage> {
  int numOfTimeSlots = 0;
  Future<Map> _gigListFuture;
  Future<SearchIndex> _searchIndexFuture;
  GigsList gigsList;
  GigListMeta metaData;
  SearchIndex searchIndex;
  int groupMode;

  bool isGigListVis = true;
  bool isLoading = false;

  double searchBarHeight = 0;

  SearchView searchViewObj = SearchView();

  var location = "Brisbane";
  int numOfGigs = 0;

  void searchView() {
    print(searchViewObj.getView());
    setState(() {
      searchViewObj.changeView();
    });
    print(searchViewObj.getView());
  }

  void setLoading(b) {
    setState(() {
      isLoading = b;
    });
  }

  // load data and set state
  void loadData() {
    print("Getting Data");
    setLoading(true);
    _gigListFuture = getGigs(1);
    _gigListFuture.then((r) {
      metaData = r['meta'];
      numOfGigs = metaData.metadata['num_of_gigs'];
      
      // Number of timeslots (5pm, 5:30pm...)
      r['events'].gigs.forEach((k, v) => numOfTimeSlots += 1);

      // Define list group mode (0 = by time, 1 = by date)
      // used in Future builder to define which method to format header titles
      groupMode = metaData.metadata["group_mode"];
      isLoading = false;
      setState(() {});
    });

    _searchIndexFuture = getSearchIndex();
    _searchIndexFuture.then((r) {
      searchIndex = r;
    });
    print("Got Data, Stop loading icon");
  }

  @override
  void initState() {
    super.initState();
    loadData();
    searchViewObj.setVals(isGigListVis, searchBarHeight);
  }

  Future<void> refreshGigData() async {
    numOfTimeSlots = 0;
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DefaultDrawer(
        context: context,
      ),
      backgroundColor: hexToColor('#D9D9D9'),
      body: SafeArea(
        top: true,
        //minimum: EdgeInsets.only(top: 60.0),
        child: RefreshIndicator(
          displacement: 40,
          onRefresh: refreshGigData,
          child: CustomScrollView(
            slivers: <Widget>[
              //SliverAppBar(),
              RowAppBar(
                numOfGigs: numOfGigs,
                location: location,
                t: searchViewObj,
                setState: searchView,),

              (!searchViewObj.getView())
                  ? SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          SearchPage(
                            //searchBarHeight: searchBarHeight,
                            searchView: searchViewObj,
                            searchIndex: searchIndex,
                            context: context,
                          ),
                        ],
                      ),
                    )
                  : (!isLoading)
                      ? SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return FutureBuilder<Map>(
                                future: _gigListFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    //setLoading(false);
                                    final gigs = snapshot.data['events'];
                                    while (index < numOfTimeSlots) {
                                      var headerTitleKey;
                                      var headerTitleFormatted;

                                      headerTitleKey =
                                          gigs.gigs.keys.toList()[index];

                                      headerTitleFormatted = formatGroupTitle(
                                          groupMode, headerTitleKey);

                                      return GigListContainer(
                                          context: context,
                                          index: index,
                                          gigs: gigs,
                                          headerTitleKey: headerTitleKey,
                                          headerTitleFormatted:
                                              headerTitleFormatted,
                                          groupMode: groupMode,
                                          numOfGigs: numOfGigs,
                                          vis: isGigListVis,
                                          refPage: 1,);
                                    }
                                  } else if (snapshot.hasError) {
                                    print(snapshot.error);
                                    return Text(snapshot.error.toString());
                                  }
                                  return SizedBox();
                                },
                              );
                            },
                            childCount: numOfTimeSlots,
                            addAutomaticKeepAlives: true,
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildListDelegate([
                          Container(
                            child: Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 32.0),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                          )
                        ]))
            ],
          ),
        ),
      ),
    );
  }
}
