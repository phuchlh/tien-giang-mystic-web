import 'package:equatable/equatable.dart';

class PlaceModel extends Equatable {
  final int id;
  final String image;
  final String title;
  final String location;

  const PlaceModel({
    required this.id,
    required this.image,
    required this.title,
    required this.location,
  });

  @override
  List<Object?> get props => [id, image, title, location];
}
