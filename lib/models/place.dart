import 'package:uuid/uuid.dart';

/// Uuid instance to generate unique identifiers
const uuid = Uuid();

/// Place model, which contains the information of a place
class Place {
  final String id;
  final String name;
  final String description;
  // final String image;
  // final String location;

  /// Create a new place with the given information
  /// [name] is the name of the place
  /// [description] is the description of the place
  /// [image] is the image of the place
  /// [location] is the location of the place
  /// [id] is the unique identifier of the place
  Place({
    required this.name,
    required this.description,
    // required this.image,
    // required this.location,
  }) : id = uuid.v4();
}
