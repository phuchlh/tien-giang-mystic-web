import 'package:equatable/equatable.dart';

class LabelModel extends Equatable {
  String? id;
  String? labelName;
  String? createdAt;
  bool? isActive;

  LabelModel({this.id, this.labelName, this.createdAt, this.isActive});

  LabelModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    labelName = json['label_name'];
    createdAt = json['created_at'];
    isActive = json['is_active'] ?? true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['label_name'] = labelName;
    data['created_at'] = createdAt;
    data['is_active'] = isActive;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, labelName, createdAt, isActive];
}
