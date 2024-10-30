import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:my_places/models/place.dart';
import 'package:my_places/pages/map.dart';

class LocationInput extends StatefulWidget {
  final void Function(PlaceLocation location) onLocationSelected;

  const LocationInput({super.key, required this.onLocationSelected});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  final _apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];

  /// Saves the location to the state and calls the callback
  /// to inform the parent widget about the selected location
  ///
  /// Parameters:
  /// - [latitude]: The latitude of the location
  /// - [longitude]: The longitude of the location
  Future<void> _savePlace(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$_apiKey');

    final response = await http.get(url);
    final data = json.decode(response.body);
    final address = data['results'][0]['formatted_address'];

    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: latitude,
        longitude: longitude,
        address: address,
      );
      _isGettingLocation = false;
    });

    widget.onLocationSelected(_pickedLocation!);
  }

  /// Fetches the current location and saves it
  /// to the state
  void _getCurrentLocation() async {
    final location = Location();

    if (!await _checkServiceEnabled(location)) return;
    if (!await _checkPermissionGranted(location)) return;

    setState(() {
      _isGettingLocation = true;
    });

    final locationData = await location.getLocation();

    if (locationData.latitude == null || locationData.longitude == null) {
      // TODO: inform user that location could not be fetched
      setState(() {
        _isGettingLocation = false;
      });
      return;
    }

    _savePlace(locationData.latitude!, locationData.longitude!);
  }

  /// Opens the map page to select a location
  /// and saves the location when selected
  void _selectOnMap() async {
    final pickedLocation = await Navigator.of(context).push<LatLng>(
      CupertinoPageRoute(builder: (context) => const MapPage()),
    );

    if (pickedLocation == null) return;

    _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  /// Checks if the location service is enabled
  Future<bool> _checkServiceEnabled(Location location) async {
    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }
    return serviceEnabled;
  }

  /// Checks if the location permission is granted
  Future<bool> _checkPermissionGranted(Location location) async {
    var permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }
    return permissionGranted == PermissionStatus.granted;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoFormRow(
      prefix: const Text('Location'),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _previewContent(),
          const SizedBox(width: 16),
          CupertinoButton(
            onPressed: _selectOnMap,
            child: const Icon(CupertinoIcons.map),
          ),
          CupertinoButton(
            onPressed: _getCurrentLocation,
            child: const Icon(CupertinoIcons.location),
          ),
        ],
      ),
    );
  }

  Widget _previewContent() {
    if (_isGettingLocation) {
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    }

    // Location is picked
    if (_pickedLocation != null) {
      // Render text if API key is not set
      if (_apiKey == null) {
        return const Text('Location Picked');
      }

      // Render image if API key is set
      return Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Image.network(
          getLocationImage(_pickedLocation!),
          fit: BoxFit.cover,
          width: 50,
          height: 50,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

/// Returns the URL for the static map image of the location
///
/// Parameters:
/// - [location]: The location for which the image is to be fetched
String getLocationImage(PlaceLocation location) {
  return 'https://maps.googleapis.com/maps/api/staticmap?center=${location.latitude},${location!.longitude}&zoom=16&size=400x200&markers=color:red%7Clabel:A%7C${location!.latitude},${location!.longitude}&key=${dotenv.env['GOOGLE_MAPS_API_KEY']}';
}
