import 'dart:io';

import 'package:my_places/db/db_helper.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_places/models/place.dart';

class UserPlacesState {
  final List<Place> places;
  final bool isLoading;
  final String? hasError;

  UserPlacesState({
    required this.places,
    required this.isLoading,
    this.hasError,
  });

  UserPlacesState copyWith({
    List<Place>? places,
    bool? isLoading,
    String? hasError,
  }) {
    return UserPlacesState(
      places: places ?? this.places,
      isLoading: isLoading ?? this.isLoading,
      hasError: this.hasError,
    );
  }
}

/// Notifier for user places,
/// it will be used to add and remove places from the user's list
/// of places.
class UserPlacesNotifier extends StateNotifier<UserPlacesState> {
  UserPlacesNotifier()
      : super(UserPlacesState(
          places: [],
          isLoading: false,
          hasError: null,
        ));

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
    try {
      state = state.copyWith(isLoading: true, hasError: null);
      final places = await DBHelper.getPlaces();
      state = state.copyWith(places: places);
    } catch (error) {
      state = state.copyWith(
          hasError: 'Failed to load places: ${error.toString()}');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Add a new place to the user's list of places.
  ///
  /// Parameters:
  /// - [place] the place to be added to the list of places.
  Future<void> addPlace(Place place) async {
    try {
      state = state.copyWith(isLoading: true, hasError: null);
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

      await DBHelper.insertPlace(newPlace);
      state = state.copyWith(places: [...state.places, newPlace]);
    } catch (error) {
      state =
          state.copyWith(hasError: 'Failed to add place: ${error.toString()}');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Remove a place from the user's list of places.
  ///
  /// [place] the place to be removed from the list of places.
  Future<void> removePlace(Place place) async {
    try {
      state = state.copyWith(isLoading: true, hasError: null);

      // Delete the image file from the app's directory
      place.image.delete();

      // Delete the place from the database
      await DBHelper.deletePlace(place.id);
      state = state.copyWith(
        places: state.places.where((p) => p.id != place.id).toList(),
      );
    } catch (error) {
      state = state.copyWith(
          hasError: 'Failed to remove place: ${error.toString()}');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, UserPlacesState>(
  (ref) => UserPlacesNotifier(),
);
