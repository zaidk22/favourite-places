import 'package:flutter/material.dart';

import '../../PlaceModel.dart';
import '../places_details.dart';


class PlaceList extends StatelessWidget {
   PlaceList({super.key, required this.places});
  final List<placeModel> places;

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return const Center(
        child: Text("No places added yet"),
      );
    }
    return ListView.builder(
      itemCount: places?.length,
      itemBuilder: (context, index) => ListTile(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlaceDetailsScreen(place: places[index]),)),
        leading: CircleAvatar(
          radius: 26,
          backgroundImage: FileImage(places[index].image),
        ),
        title: Text(places[index].title,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Theme.of(context).colorScheme.onBackground)),
        subtitle: Text("${places[index].location?.latitude}",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Theme.of(context).colorScheme.onBackground)
        ),
      ),
    );
  }
}
