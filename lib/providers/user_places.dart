import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_places/models/place.dart';

/// Notifier for user places,
/// it will be used to add and remove places from the user's list
/// of places.
class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  /// Add a place to the user's list of places.
  ///
  /// [place] the place to be added to the list of places.
  void addPlace(Place place) {
    state = [place, ...state];
  }

  // void removePlace(Place place) {
  //   state = state.where((element) => element != place).toList();
  // }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) => UserPlacesNotifier(),
);
