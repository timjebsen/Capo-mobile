import 'dart:convert';

class VenueModel {
  final String address;
  final String suburb;
  final String description;
  final String googlePlaceId;
  final Map<String, dynamic> socials;
  final String price;
  final String ticket;
  final String rating;
  final String venueName;
  final List venueType;
  final List hours;
  final String venueId;
  final bool openStatus;
  final bool hasImage;
  final Map<String, dynamic> imageLinks;

  VenueModel(
      {this.address,
      this.googlePlaceId,
      this.socials,
      this.price,
      this.ticket,
      this.suburb,
      this.hours,
      this.rating,
      this.description,
      this.venueId,
      this.venueType,
      this.venueName,
      this.openStatus,
      this.hasImage,
      this.imageLinks});

  factory VenueModel.fromMap(Map<String, dynamic> map) {
    List type;
    if (map["types"] == []) {
      type = ['null'];
    } else {
      type = map["types"];
    }

    return VenueModel(
        venueName: map["name"],
        googlePlaceId: map["google_place_id"],
        socials: map["socials"],
        price: map["price"],
        ticket: map["ticket"],
        rating: map["time"],
        suburb: map["suburb"],
        description: map["description"],
        venueType: type,
        venueId: map["id"],
        address: map["address"],
        openStatus: map["open_status"],
        hasImage: map["has_img"] == 0 ? false : true,
        imageLinks: map["img_links"],
        );
  }
  operator [](index) => venueType[index];
}

class VenueList {
  final List<VenueModel> venues;

  VenueList({
    this.venues,
  });

  factory VenueList.fromJson(List parsedJson) {
    List<VenueModel> venueList = List<VenueModel>();
    
    for (int i = 0; i < parsedJson.length; i ++){
      VenueModel venue = VenueModel.fromMap(parsedJson[i]);
      venueList.add(venue);
    }
    // venueList = parsedJson['venue_list'];

    return VenueList(
      venues: venueList,
    );
  }
  operator [](index) => venues[index];

  int get length {
    return this.venues.length;
  }
  
  set add(VenueModel venue) {
    this.venues.add(venue);
  }

  // get listOfIndexWithMatchingFilter(String type){
  //   List<int> listofIndex = [];
  //   for(int i = 0; i < this.venues.length; i ++){
  //     VenueModel venue = this.venues[i];
  //     for (String each in venue.venueType) {
  //       if (each == type){
  //         listofIndex.add(i);
  //       }
  //     }
  //   }
  //   return listofIndex;
  // }

  // set remove(String venue) {
  //   this.venues.
  // }

  // void removeAllVenuesByType(String venueType){
  //   for(int i = 0; i < this.venues.length; i ++){
  //     VenueModel venue = this.venues[i];
  //     for (String each in venue.venueType) {
  //       if (each == venueType){
  //         this.venues.remove(this.venues[i].venueName);
  //       }
  //     }
  //   }

  // }


   
}