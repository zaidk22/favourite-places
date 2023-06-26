import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class PlaceLocation{
  const PlaceLocation({required this.longitude, required this.latitude,required this.address});
  final double latitude;
  final double longitude;
  final String address;
}
class placeModel {
  placeModel({required this.title,required this.image,
    required this.location,
    String? id

  }) : id = id ??uuid.v4();

  final String id;
  final String title;
  final File image;
  final PlaceLocation location;
}
