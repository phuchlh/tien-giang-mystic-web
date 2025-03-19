import 'package:equatable/equatable.dart';

class PlaceModel extends Equatable {
  String? id;
  String? ticket;
  String? address;
  String? comment;
  double? latitude;
  double? longitude;
  String? placeName;
  String? visitTime;
  String? description;
  String? likeNumber;
  String? placeLabel;
  String? viewNumber;
  String? phoneNumber;
  String? openCloseHour;
  String? placeImageFolder;

  PlaceModel(
      {this.id,
      this.ticket,
      this.address,
      this.comment,
      this.latitude,
      this.longitude,
      this.placeName,
      this.visitTime,
      this.description,
      this.likeNumber,
      this.placeLabel,
      this.viewNumber,
      this.phoneNumber,
      this.openCloseHour,
      this.placeImageFolder});

  PlaceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ticket = json['ticket'];
    address = json['address'];
    comment = json['comment'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    placeName = json['place_name'];
    visitTime = json['visit_time'];
    description = json['description'];
    likeNumber = json['like_number'];
    placeLabel = json['place_label'];
    viewNumber = json['view_number'];
    phoneNumber = json['phone_number'];
    openCloseHour = json['open_close_hour'];
    placeImageFolder = json['place_image_folder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ticket'] = ticket;
    data['address'] = address;
    data['comment'] = comment;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['place_name'] = placeName;
    data['visit_time'] = visitTime;
    data['description'] = description;
    data['like_number'] = likeNumber;
    data['place_label'] = placeLabel;
    data['view_number'] = viewNumber;
    data['phone_number'] = phoneNumber;
    data['open_close_hour'] = openCloseHour;
    data['place_image_folder'] = placeImageFolder;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        ticket,
        address,
        comment,
        latitude,
        longitude,
        placeName,
        visitTime,
        description,
        likeNumber,
        placeLabel,
        viewNumber,
        phoneNumber,
        openCloseHour,
        placeImageFolder
      ];
}
