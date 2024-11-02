import 'dart:io';

import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

/// Uuid instance to generate unique identifiers
const uuid = Uuid();

/// Place model, which contains the information of a place
class Place {
  final String id;
  final String name;
  final String description;
  final DateTime date;
  final File image;
  final PlaceLocation location;

  /// Create a new place with the given information
  ///
  /// - [name] is the name of the place
  /// - [description] is the description of the place
  /// - [image] is the image of the place
  /// - [location] is the location of the place
  /// - [date] is the date when the place was added
  /// - [id] is the unique identifier of the place
  Place({
    required this.name,
    required this.description,
    required this.image,
    required this.location,
    String? id,
    DateTime? date,
  })  : id = id ?? uuid.v4(),
        date = date ?? DateTime.now();

  /// Get the formatted date of the place
  /// The date is formatted as "EEEE, MMMM d, y"
  String getFormattedDate() {
    final DateFormat formatter = DateFormat('EEEE, MMMM d, y');
    return formatter.format(date);
  }
}

/// PlaceLocation model, which contains the location information of a place
/// It contains the latitude, longitude, and address of the place
class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;

  /// Create a new place location with the given information
  /// - [latitude] is the latitude of the location
  /// - [longitude] is the longitude of the location
  /// - [address] is the address of the location
  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}
