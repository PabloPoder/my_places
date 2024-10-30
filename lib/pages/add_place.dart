import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_places/models/place.dart';

import 'package:my_places/providers/user_places.dart';
import 'package:my_places/widgets/image_input.dart';
import 'package:my_places/widgets/location_input.dart';

/// A page that allows the user to add a new place.
///
/// This page provides a form for the user to enter the name, description,
/// and image of a new place. It uses a [ConsumerStatefulWidget] to interact
/// with the [UserPlacesNotifier] provider.
class AddPlacePage extends ConsumerStatefulWidget {
  const AddPlacePage({super.key});

  @override
  ConsumerState<AddPlacePage> createState() => _AddPlacePageState();
}

class _AddPlacePageState extends ConsumerState<AddPlacePage> {
  /// Controllers for the name and description text fields.
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  /// Variables to store the selected image and location.
  File? _selectedImage;

  /// The selected location of the place.
  PlaceLocation? _selectedLocation;

  /// Save the place using the [UserPlacesNotifier] provider.
  ///
  /// This method validates the input fields and shows an error dialog
  /// if any field is empty. If all fields are filled, it creates a new
  /// [Place] object and adds it to the list of places using the provider.
  void _savePlace() {
    final name = _nameController.text;
    final description = _descriptionController.text;

    if (name.isEmpty ||
        description.isEmpty ||
        _selectedImage == null ||
        _selectedLocation == null) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Error'),
            content: const Text('Please fill in all fields'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    final place = Place(
      name: name,
      description: description,
      image: _selectedImage!,
      location: _selectedLocation!,
    );

    ref.read(userPlacesProvider.notifier).addPlace(place);

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    /// Dispose the controllers to avoid memory leaks
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: true,
        middle: const Text('Add Place'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _savePlace,
          child: const Text('Save'),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              CupertinoFormSection(
                header: const Text('Place Details'),
                children: <Widget>[
                  CupertinoFormRow(
                    prefix: const Text('Name'),
                    child: CupertinoTextFormFieldRow(
                      controller: _nameController,
                      autocorrect: true,
                      placeholder: 'Enter place name',
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  CupertinoFormRow(
                    prefix: const Text('Description'),
                    child: CupertinoTextFormFieldRow(
                      controller: _descriptionController,
                      autocorrect: true,
                      textCapitalization: TextCapitalization.sentences,
                      placeholder: 'Enter place description',
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  ImageInput(
                    onSelectImage: (image) {
                      _selectedImage = image;
                    },
                  ),
                  LocationInput(
                    onLocationSelected: (location) {
                      _selectedLocation = location;
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
