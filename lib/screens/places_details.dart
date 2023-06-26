import 'package:flutter/material.dart';

import '../PlaceModel.dart';


class PlaceDetailsScreen extends StatelessWidget {
  const PlaceDetailsScreen({super.key,required this.place});
  final placeModel place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Stack(
        children: [
          Image.file(place.image,
          fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

        ],
      ),
    );
  }
}
