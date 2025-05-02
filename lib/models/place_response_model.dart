import 'package:tien_giang_mystic/models/place_model.dart';

class PlaceResponse {
  String? id;
  String? chatId;
  List<PlaceModel>? listData;

  PlaceResponse({this.id, this.chatId, this.listData});

  PlaceResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chatId = json['chat_id'];
    if (json['list_data'] != null) {
      listData = <PlaceModel>[];
      json['list_data'].forEach((v) {
        listData!.add(PlaceModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['chat_id'] = chatId;
    if (listData != null) {
      data['list_data'] = listData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
