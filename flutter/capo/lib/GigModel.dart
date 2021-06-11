import 'dart:convert';

class GigModel {
  final String artistName;
  final String date;
  final String fbLink;
  final String gigId;
  final int price;
  final bool ticket;
  final int time;
  final String venueName;
  final String suburb;
  final String bio;
  final String artistId;
  final String venueId;
  final List genre;

  GigModel(
      {this.artistName,
      this.date,
      this.fbLink,
      this.gigId,
      this.price,
      this.ticket,
      this.time,
      this.venueName,
      this.suburb,
      this.bio,
      this.artistId,
      this.venueId,
      this.genre});

  factory GigModel.fromMap(Map<String, dynamic> map) {
    // 
    return GigModel(
        artistName: map["artist_name"],
        date: map["date"],
        fbLink: map["facebook_event_link"],
        gigId: map["gig_id"],
        price: map["price"],
        ticket: map["ticket"] == 0 ? false : true,
        time: map["time"],
        venueName: map["venue_name"],
        suburb: map["suburb"],
        bio: map["bio"],
        artistId: map["artist_id"],
        venueId: map["venue_id"],
        genre: map["genre"]);
  }
}

class GigsList {
  final Map<String, List<GigModel>> gigs;

  GigsList({
    this.gigs,
  });

  factory GigsList.fromJson(Map<String, dynamic> parsedJson) {
    Map<String, List<GigModel>> gigs = Map<String, List<GigModel>>();
    
    // parsedJson = parsedJson["gig_list"];
    var time = parsedJson.keys.iterator;
    while (time.moveNext()) {
      // create empty list of gig models
      List<GigModel> gigModels = [];

      // iterate through each of the time slots and append
      // each gig to the corresponding time slot in gig models
      for (var i = 0; i < parsedJson[time.current].length; i++) {
        GigModel gig = GigModel.fromMap(parsedJson[time.current][i]);

        // append current gig model to list
        gigModels.add(gig);
      }
      gigs[time.current.toString()] = gigModels;
    }

    return GigsList(
      gigs: gigs,
    );
  }

  int get length {
    return this.gigs.length;
  }
}

class GigListMeta {
  final Map<String, dynamic> metadata;
  GigListMeta({
    this.metadata,
  });

  factory GigListMeta.fromJson(Map<String, dynamic> parsedJson) {
    Map<String, dynamic> metadata = Map<String, dynamic>();

    metadata["gigs_today"] = parsedJson["gigs_today"];
    metadata["group_mode"] = parsedJson["group_mode"];
    metadata["num_of_gigs"] = parsedJson["num_of_obj"];
    metadata["rqst"] = parsedJson["rqst"];
    metadata["time_rcvd"] = parsedJson["time_rcvd"];
    metadata["time_sent"] = parsedJson["time_sent"];

    return GigListMeta(
      metadata: metadata,
    );
  }

  GigListMeta setValues(Map<String, dynamic> parsedJson) {
    //Map<String, dynamic> metadata = Map<String, dynamic>();
    this.metadata["gigs_today"] = parsedJson["gigs_today"];
    this.metadata["group_mode"] = parsedJson["group_mode"];
    this.metadata["num_of_gigs"] = parsedJson["num_of_obj"];
    this.metadata["rqst"] = parsedJson["rqst"];
    this.metadata["time_rcvd"] = parsedJson["time_rcvd"];
    this.metadata["time_sent"] = parsedJson["time_sent"];

    return GigListMeta(
      metadata: this.metadata,
    );
  }

  GigListMeta getValues() {
    return GigListMeta(
      metadata: this.metadata,
    );
  }
}
