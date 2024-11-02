import 'dart:io';

import 'package:my_places/db/db_helper.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_places/models/place.dart';

/// Notifier for user places,
/// it will be used to add and remove places from the user's list
/// of places.
class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  // TODO: Centralize the state
  // List<Place> places;
  // bool isLoading = false;
  // bool hasError = false;

  /// Helper method to copy an image to the app's directory.
  Future<File> _copyImageToAppDirectory(
    File sourceImage,
    String fileName,
  ) async {
    final appDirectory = await syspaths.getApplicationDocumentsDirectory();
    final destinationPath = '${appDirectory.path}/$fileName';
    return await sourceImage.copy(destinationPath);
  }

  // Helper method for generating unique filename
  String _generateUniqueFileName(File image) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = path.extension(image.path);
    return 'place_$timestamp$extension';
  }

  /// Load the user's list of places from the database.
  Future<void> loadPlaces() async {
    final places = await DBHelper.getPlaces();
    state = places;
  }

  /// Add a new place to the user's list of places.
  ///
  /// Parameters:
  /// - [place] the place to be added to the list of places.
  void addPlace(Place place) async {
    final copiedImage = await _copyImageToAppDirectory(
      place.image,
      _generateUniqueFileName(place.image),
    );

    final newPlace = Place(
      name: place.name,
      description: place.description,
      image: copiedImage,
      location: place.location,
    );

    final id = await DBHelper.insertPlace(newPlace);
    if (id == -1) return;
    state = [newPlace, ...state];
  }

  /// Remove a place from the user's list of places.
  ///
  /// [place] the place to be removed from the list of places.
  void removePlace(Place place) {
    state = state.where((element) => element != place).toList();
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) => UserPlacesNotifier(),
);
