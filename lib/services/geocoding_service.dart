import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:my_places/models/place.dart';

class GeocodingService {
  /// The Google Maps API key to be used for fetching the location details
  final String? _apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];

  /// Returns the address for the given coordinates
  ///
  /// Parameters:
  /// - [lat]: The latitude of the location
  /// - [lng]: The longitude of the location
  ///
  /// Returns:
  /// - The address of the location
  Future<String> getAddressFromCoordinates(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$_apiKey');

    final response = await http.get(url);
    final data = json.decode(response.body);
    return data['results'][0]['formatted_address'];
  }

  /// Returns the URL for the static map image of the location
  ///
  /// Parameters:
  /// - [location]: The location for which the image is to be fetched
  ///
  /// Returns:
  /// - The URL for the static map image
  String getStaticMapUrl(PlaceLocation location) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=${location.latitude},${location.longitude}&zoom=16&size=400x200&markers=color:red%7Clabel:A%7C${location.latitude},${location.longitude}&key=$_apiKey';
  }
}
