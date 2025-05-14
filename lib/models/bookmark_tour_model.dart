import 'package:tien_giang_mystic/models/place_model.dart';

class BookmarkTourModel {
  List<PlaceModel>? jsonLocation;

  BookmarkTourModel({this.jsonLocation});

  BookmarkTourModel.fromJson(Map<String, dynamic> json) {
    if (json['json_location'] != null) {
      jsonLocation = <PlaceModel>[];
      json['json_location'].forEach((v) {
        jsonLocation!.add(PlaceModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (jsonLocation != null) {
      data['json_location'] = jsonLocation!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
