import 'package:equatable/equatable.dart';

class BookmarkPlace extends Equatable {
  String? id;
  String? userId;
  String? locationId;
  String? createdAt;

  BookmarkPlace({this.id, this.userId, this.locationId, this.createdAt});

  BookmarkPlace.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    locationId = json['location_id'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['location_id'] = locationId;
    data['created_at'] = createdAt;
    return data;
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        locationId,
        createdAt,
      ];
}
