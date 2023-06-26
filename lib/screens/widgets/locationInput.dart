import 'dart:convert';

import 'package:favourite_places/PlaceModel.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key,required this.onSelctLocation});
  final void Function(PlaceLocation location) onSelctLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {

  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  String getLocationImage(){
  
    final lat = _pickedLocation!.latitude;
    final long = _pickedLocation!.longitude;
    return 'http://maps.google.com/maps/api/staticmap?zoom=16&size=600x300&maptype=hybrid&markers=$lat,$long&sensor=false[/IMG]';
}

  void _getCurrentLocation()async{

    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }



    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
     setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final long = locationData.longitude;
    print("lat = ${locationData?.accuracy}");
    print("lat = ${locationData?.altitude}");
    final url = Uri.parse("https://maps.googleapis.com/maps/api/geocode/json?latlng=${locationData?.latitude},${locationData?.longitude}&key=AIzaSyAiL6wxYwOFM1RJI-HoNWmpkzw93CKBBx4");

    if(lat==null || long==null){
      return;
    }
  // final response = await  http.get(url);
  // final result = json.decode(response.body);
  // print(result);
  // final address = result['results'][0]['formatted_address'];
  //
    setState(() {
      _pickedLocation = PlaceLocation(longitude: long, latitude: lat, address: "address");
      _isGettingLocation = false;
    });
    widget.onSelctLocation(_pickedLocation!);

  }
  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text("No location Chosen",textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Theme.of(context).colorScheme.onBackground
      ),
    );
    if(_pickedLocation !=null){
      previewContent = Text(
        'latitude = ${_pickedLocation?.latitude}\n'
            'longitude = ${_pickedLocation?.longitude}'
      );
      // previewContent = Image.network(getLocationImage(),
      // fit: BoxFit.cover,
      //   width: double.infinity,
      //   height: double.infinity,
      // );
    }
    if(_isGettingLocation){
      previewContent = Center(child: CircularProgressIndicator(),);
    }
    return Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2)
            )
          ),
          child:previewContent

        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              label: Text("Get current location"),
                icon: Icon(Icons.location_on),
                onPressed: _getCurrentLocation, ),
            TextButton.icon(
              label: Text("Select on Map"),
              icon: Icon(Icons.map),
              onPressed: (){}, ),
          ],
        )
      ],
    );
  }
}
