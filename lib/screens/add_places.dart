import 'package:favourite_places/PlaceModel.dart';
import 'package:favourite_places/screens/widgets/input_image.dart';
import 'package:favourite_places/screens/widgets/locationInput.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/user_places.dart';


class AddPlacesScreen extends ConsumerStatefulWidget {
  const AddPlacesScreen({super.key});

  @override
  ConsumerState<AddPlacesScreen> createState() => _AddPlacesScreenState();
}

class _AddPlacesScreenState extends ConsumerState<AddPlacesScreen> {
  final _titleController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void _savePlace() {
    final enteredText = _titleController.text;
    if (enteredText.isEmpty||_selectedImage==null
        || _selectedLocation ==null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Feilds cannot be empty")));
      return;
    }
    ref.read(userPlacesProvider.notifier).addPlace(enteredText,_selectedImage!,_selectedLocation!);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add places"),
      ),
      body:  SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Title',
              ),
              controller: _titleController,
              style:
              TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
            SizedBox(
              height: 16,
            ),
            ImageInput(onPickImage: (image) {
              _selectedImage=image;
            },),
            SizedBox(
              height: 16,
            ),
            LocationInput(onSelctLocation: (location) {
              _selectedLocation = location;
            },),

            SizedBox(
              height: 16,
            ),
            ElevatedButton.icon(
              label: Text("Add Place"),
                icon: Icon(Icons.add),
                onPressed: _savePlace,
            )
          ],
        ),
      ),
    );
  }
}
