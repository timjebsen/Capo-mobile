class SearchView {
  double searchBarHeight;
  bool isGigListVis;

  SearchView({
    this.searchBarHeight,
    this.isGigListVis,
  });

  // factory SearchView.changeView(bool isGigListVis){
  //   double searchBarHeight;
  //   if (isGigListVis) {
  //       isGigListVis = false;
  //       searchBarHeight = 65;
  //   } else {
  //       searchBarHeight = 0;
  //       isGigListVis = true;
  //   }
  //   return SearchView(isGigListVis: isGigListVis, searchBarHeight: searchBarHeight);
  // }

  void setVals(bool isGigListVis, double searchBarHeight) {
    this.searchBarHeight = searchBarHeight;
    this.isGigListVis = isGigListVis;
  }

  void changeView() {
    if (this.isGigListVis) {
      //print(this.isGigListVis);
      this.isGigListVis = false;
      this.searchBarHeight = 65;
    } else {
      this.searchBarHeight = 0;
      this.isGigListVis = true;
    }
  }

  bool getView() {
    return this.isGigListVis;
  }

  double getSearchBarHeight(){
    return this.searchBarHeight;
  }

  // factory SearchView.getCurrentView() {

  //   return(isGigListVis: isGigListVis)
  // }

}
