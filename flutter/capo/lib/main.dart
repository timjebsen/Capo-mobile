import 'package:flutter/material.dart';
import 'SearchIndexModel.dart';
import 'GigModel.dart';
import 'GigListCont.dart';
import 'funcs.dart';
import 'Drawer.dart';
import 'SearchPage.dart';
import 'package:flutter/services.dart';
import 'SearchView.dart';
import 'HomeAppBar.dart';
import 'Routes.dart';
import 'RestOfWeekPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    title: "capo",
    home: Home(),
  ));
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black, // navigation bar color
      statusBarColor: hexToColor('#3B3B3B'), // status bar color
    ),
  );
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test',
      home: HomePage(),
      theme: ThemeData(
          fontFamily: 'Archivo',
          brightness: Brightness.light,
          primaryColor: hexToColor('#242424'),
          accentColor: hexToColor('#f5582c'), //hexToColor('#DA4E27'),
          backgroundColor: hexToColor('#c9c9c9'),
          textTheme: TextTheme(body1: TextStyle(color: hexToColor('#5b5b5b'))),
          buttonTheme: ButtonThemeData()
          // accentTextTheme:
          // textTheme: TextTheme(display1: TextStyle(color: hexToColor('#E9E9E9')),display2: Te)
          ),
    );
  }
}

int numOfGigs = 0;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int numOfTimeSlots;
  Future<Map> _gigListFuture;
  Future<SearchIndex> _searchIndexFuture;
  GigsList gigsList;
  GigListMeta metaData;
  SearchIndex searchIndex;
  int groupMode;
  String forecast;
  bool isGigListVis = true;
  bool isLoading = false;
  String location;

  double searchBarHeight = 0;

  SearchView searchViewObj = SearchView();

  void restOfWeekPage() {
    Navigator.push(
        context, MyCustomRoute(builder: (context) => RestOfWeekPage()));
  }

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
    _gigListFuture = getGigs(0);
    _gigListFuture.then((r) {
      metaData = r['meta'];
      if (metaData.metadata['gigs_today']) {
        numOfGigs = metaData.metadata['num_of_gigs'];
        forecast = "Today";
      } else {
        numOfGigs = metaData.metadata['num_of_gigs'];
        forecast = "Upcoming";
        print(r['events']);
      }
      // Number of timeslots (5pm, 5:30pm...)
      numOfTimeSlots = r['events'].gigs.keys.toList().length;

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
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _clearLocation();
    // _askLocation();
    // loadData();
    searchViewObj.setVals(isGigListVis, searchBarHeight);
  }

  Future<void> refreshGigData() async {
    numOfTimeSlots = 0;
    loadData();
  }

  _saveLocation(String location) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'location';
    prefs.setString(key, location);
  }

  _clearLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'location';
    prefs.setString(key, null);
  }

  Future<String> _getSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'location';
    return prefs.getString(key);
  }

  bool islocationSet(){
    bool b = false;
    // _getSavedLocation.then(r){
    //   if (r != null) {
    //     b = true;
    //   }
    // };
    if (_getSavedLocation != null){
       b = true;
    }
    print(metaData);
    return b;
  }

  Widget _askLocation() {
    print('hert');
    TextStyle opStyle = TextStyle(
      // backgroundColor: Colors.white38,
      color: Theme.of(context).backgroundColor,
      fontFamily: 'Staatliches',
      // fontWeight: FontWeight.bold,
      fontSize: 32,
    );
    TextStyle headerStyle = TextStyle(
      color: Theme.of(context).accentColor,
      fontFamily: 'Staatliches',
      fontWeight: FontWeight.bold,
      fontSize: 40,
    );
    if (location == null) {
      return SimpleDialog(
        elevation: 10,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'A Night out in:',
          style: headerStyle,
          textAlign: TextAlign.center,
        ),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () {
              
              location = 'Brisbane';
              _saveLocation(location);
              loadData();
            },
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    border: Border.all(
                        color: Theme.of(context).backgroundColor,

                        )),
                child: Text(
                  'Brisbane',
                  style: opStyle,
                  textAlign: TextAlign.center,
                )),
          ),
          SimpleDialogOption(
            onPressed: () {
              location = 'Gold Coast';
              _saveLocation(location);
              loadData();
              // location = 'Brisbane';
            },
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    border: Border.all(
                        color: Theme.of(context).backgroundColor,
                        )),
                child: Text(
                  'Gold Coast',
                  style: opStyle,
                  textAlign: TextAlign.center,
                )),
          ),
        ],
      );
    } else {
      return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DefaultDrawer(
        context: context,
      ),
      backgroundColor: Colors.white70, //hexToColor('#D9D9D9'),
      body: (!islocationSet() || metaData == null) ? _askLocation() :
          SafeArea(
        top: true,
        //minimum: EdgeInsets.only(top: 60.0),
        child: RefreshIndicator(
          displacement: 40,
          onRefresh: refreshGigData,
          child: CustomScrollView(
            physics: globalScrollPhysics(),
            slivers: <Widget>[
              //SliverAppBar(),
              AppBarLoc(
                forecast: forecast,
                numOfGigs: numOfGigs,
                location: location,
                t: searchViewObj,
                setState: searchView,
              ),

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
                                        refPage:
                                            0, // refPage = what page is building the list
                                      );
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
                          delegate: SliverChildListDelegate(
                            [
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
                            ],
                          ),
                        ),
              (searchViewObj.getView())
                  ? SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Container(
                              child: Container(
                                height: 50,
                                width: 350,
                                child: RaisedButton(
                                  elevation: 4,
                                  color: Theme.of(context).accentColor,
                                  colorBrightness: Brightness.dark,
                                  onPressed: restOfWeekPage,
                                  child: Text(
                                    'Rest of the week',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontFamily: 'Staatliches'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildListDelegate([]),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
