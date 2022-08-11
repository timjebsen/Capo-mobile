class SearchIndex {
  final List<Map<String, dynamic>> indexList;

  SearchIndex({
    this.indexList,
  });
  
  factory SearchIndex.fromJson(List<dynamic> parsedJson) {
    List<Map<String, dynamic>> indexList =List<Map<String, dynamic>>();
    // print(parsedJson[0]['dbid']);
    for(var i=0;i<parsedJson.length;i++){
      
      String dbid = parsedJson[i]['dbid'];
      int dbtbl = parsedJson[i]['dbtbl'];
      String text = parsedJson[i]['text'];
      
      Map<String, dynamic> item = {
        'dbid': dbid,
        'dbtbl': dbtbl,
        'text': text,

      };
      indexList.add(item);
    }
    return SearchIndex(
      indexList: indexList,
    );
  }
}