import 'dart:math';
import 'package:flutter/material.dart';
import 'package:capo/SearchIndexModel.dart';
import 'funcs.dart';
import 'SearchView.dart';
import 'Routes.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    Key key,
    @required this.searchView,
    @required this.searchIndex,
    @required this.context,
  }) : super(key: key);

  final SearchView searchView;
  final SearchIndex searchIndex;
  final BuildContext context;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isTextInput = false;
  TextEditingController myController;
  String inputText;
  List suggestionList = [];
  List searchIndexList;
  bool isSuggestionLoading = false;

  void initState() {
    super.initState();
    myController = TextEditingController();
    searchIndexList = widget.searchIndex.indexList;
  }

  String normaliseString(String text){
    String normalisedText = text.toString().toLowerCase();
    normalisedText = normalisedText.replaceAll(" ", "");
    return normalisedText;
  }

  void onInput(value) {
    if (value != "") {
      setState(() {
        isSuggestionLoading = true;
      });

      isTextInput = true;
      inputText = value;
      // Normalise input text
      String inputTextNormalised = normaliseString(inputText);

      suggestionList.clear();
      for (var each in searchIndexList) {
        String textFor = each['text'].toString().toLowerCase();
        textFor = textFor.replaceAll(" ", "");
        if (textFor.contains(inputTextNormalised)) {
          //print(each['text'].contains(value.toString()));
          suggestionList.add(each);
        }
      }

      setState(() {
        isSuggestionLoading = false;
      });
    } else {
      setState(() {
        isTextInput = false;
        suggestionList.clear();
      });
    }
  }

  void selectionFunc(suggestion) {
    int type = suggestion['dbtbl'];
    if (type == 0) {
      artistPage(context, suggestion['dbid'], suggestion['text']);
    } else if (type == 1) {
      venuePage(context, suggestion['dbid']);
    } else if (type == 2) {
    } else if (type == 3) {
      searchRegionPage(context, suggestion['dbid'], suggestion['text']);
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          height: widget.searchView.getSearchBarHeight(),
          //color: Theme.of(context).primaryColor,
          // duration: Duration(milliseconds: 100),
          child: Align(
            alignment: Alignment.center,
            child: Container(
              // decoration: (1 == 1) ? Text("Test") : BoxDecoration() ,
              width: 350,
              height: 45,
              // color: Colors.white,
              child: Stack(
                children: <Widget>[
                  TextField(
                    controller: myController,
                    onChanged: (String value) {
                      onInput(value);
                    },
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        borderSide: BorderSide(
                          width: 4,
                          style: BorderStyle.solid,
                        ),
                      ),
                      hintText: 'Artist, Venue, Genre...',
                      hintStyle: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Archivo',
                          color: Colors.black54),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                  (isSuggestionLoading)
                      ? Container(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator()),
                          ),
                        )
                      : SizedBox()
                ],
              ),
            ),
          ),
        ),
        (isTextInput)
            ? SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: suggestionList.length,
                      itemBuilder: (context, index) {
                        // 0 = artist
                        // 1 = venue
                        // 2 = genre
                        // 3 = region
                        String suggestionType = '';
                        IconData icon;
                        if (suggestionList[index]['dbtbl'] == 0) {
                          suggestionType = 'Artist';
                          icon = Icons.music_note;
                        } else if (suggestionList[index]['dbtbl'] == 1) {
                          suggestionType = 'Venue';
                          icon = Icons.local_bar;
                        } else if (suggestionList[index]['dbtbl'] == 2) {
                          suggestionType = 'Genre';
                          icon = Icons.art_track;
                        } else if (suggestionList[index]['dbtbl'] == 3) {
                          suggestionType = 'Events & Venues';
                          icon = Icons.place;
                        }
                        return Container(
                          decoration: BoxDecoration(
                            // boxShadow: ,
                            //color: Colors.white70,
                            border: Border(
                              top: (index == 0) ? BorderSide(color: Colors.black12, width: 1) :
                              BorderSide(color: Colors.black12, width: 0) ,
                              bottom: 
                                  BorderSide(color: Colors.black12, width: 1),
                            ),
                          ),
                          child: ListTile(
                            leading: Icon(icon, size: 20, color: Colors.black),
                            enabled: true,
                            onTap: () => selectionFunc(suggestionList[index]),
                            title: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontFamily: 'Staatliches'),
                                    text: suggestionList[index]['text']
                                        .toString(),
                                  ),
                                  TextSpan(
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 14,
                                      color: Colors.black45,
                                      fontFamily: 'Staatliches',
                                    ),
                                    text: ' - ' + suggestionType,
                                  ),
                                ],
                              ),
                            ),
                            dense: true,
                          ),
                        );
                      }),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
