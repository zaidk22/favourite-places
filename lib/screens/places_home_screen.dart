import 'package:favourite_places/screens/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/user_places.dart';
import 'add_places.dart';


class PlacesHomeScreen extends ConsumerStatefulWidget {
  const PlacesHomeScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
   return _PlacesHomeScreenState();
  }

}
  class _PlacesHomeScreenState extends ConsumerState<PlacesHomeScreen>{

  late Future<void> _placesFuture;
  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(userPlacesProvider.notifier).loadPlaces();
  }
  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(userPlacesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Places"),
        actions: [IconButton(onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddPlacesScreen(),));
        }, icon: Icon(Icons.add))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _placesFuture,
          builder: (context, snapshot) {
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            else{
              return PlaceList(places: userPlaces);
            }
          },
        ),
      ),
    );

  }
}
