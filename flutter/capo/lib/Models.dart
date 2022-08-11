// // TODO put all misc model structures here
// import 'dart:convert';

// class ImageModel {
//   final String address;
//   final String suburb;
//   final String description;
//   final String googlePlaceId;

//   ImageModel(
//       {this.address,
//       this.googlePlaceId,
//       this.socials,});

//   factory ImageModel.fromMap(Map<String, dynamic> map) {
//     return ImageModel(
//         venueName: map["venue_name"],
//         googlePlaceId: map["google_place_id"],
//         socials: map["facebook_event_link"],
//         price: map["price"],
//         ticket: map["ticket"],
//         rating: map["time"],
//         suburb: map["suburb"],
//         description: map["description"],
//         venueType: type,
//         venueId: map["venue_id"],
//         address: map["address"],
//         openStatus: map["open_status"]);
//   }
//   operator [](index) => venueType[index];
// }

// class VenueList {
//   final List<ImageModel> venues;

//   VenueList({
//     this.venues,
//   });

//   factory VenueList.fromJson(List parsedJson) {
//     List<ImageModel> venueList = List<ImageModel>();
    
//     for (int i = 0; i < parsedJson.length; i ++){
//       ImageModel venue = ImageModel.fromMap(parsedJson[i]);
//       venueList.add(venue);
//     }
//     // venueList = parsedJson['venue_list'];

//     return VenueList(
//       venues: venueList,
//     );
//   }
//   operator [](index) => venues[index];

//   int get length {
//     return this.venues.length;
//   }
  
//   set add(ImageModel venue) {
//     this.venues.add(venue);
//   }

//   // get listOfIndexWithMatchingFilter(String type){
//   //   List<int> listofIndex = [];
//   //   for(int i = 0; i < this.venues.length; i ++){
//   //     ImageModel venue = this.venues[i];
//   //     for (String each in venue.venueType) {
//   //       if (each == type){
//   //         listofIndex.add(i);
//   //       }
//   //     }
//   //   }
//   //   return listofIndex;
//   // }

//   // set remove(String venue) {
//   //   this.venues.
//   // }

//   // void removeAllVenuesByType(String venueType){
//   //   for(int i = 0; i < this.venues.length; i ++){
//   //     ImageModel venue = this.venues[i];
//   //     for (String each in venue.venueType) {
//   //       if (each == venueType){
//   //         this.venues.remove(this.venues[i].venueName);
//   //       }
//   //     }
//   //   }

//   // }


   
// }