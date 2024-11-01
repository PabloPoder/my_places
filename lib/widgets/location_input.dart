import 'package:flutter/cupertino.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:my_places/models/place.dart';
import 'package:my_places/pages/map.dart';
import 'package:my_places/services/geocoding_service.dart';
import 'package:my_places/services/location_service.dart';

class LocationInput extends StatefulWidget {
  /// Callback function to be called when a location is selected
  final void Function(PlaceLocation location) onLocationSelected;

  const LocationInput({super.key, required this.onLocationSelected});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  /// Services to get the location and address
  final _locationService = LocationService();
  final _geocodingService = GeocodingService();

  /// The location that is selected
  PlaceLocation? _location;

  /// Whether the location is being fetched
  var _isGettingLocation = false;

  /// Handles the location and updates the state
  /// and calls the callback function
  ///
  /// Parameters:
  /// - [lat]: The latitude of the location
  /// - [lng]: The longitude of the location
  Future<void> _handleLocation(double lat, double lng) async {
    final address = await _geocodingService.getAddressFromCoordinates(lat, lng);
    final location = PlaceLocation(
      latitude: lat,
      longitude: lng,
      address: address,
    );

    setState(() {
      _location = location;
      _isGettingLocation = false;
    });

    widget.onLocationSelected(location);
  }

  Future<PlaceLocation?> _getCurrentLocation() async {
    if (!await _locationService.checkServiceEnabled()) return null;
    if (!await _locationService.checkPermissionGranted()) return null;

    setState(() => _isGettingLocation = true);

    final locationData = await _locationService.getCurrentLocation();
    if (locationData?.latitude == null || locationData?.longitude == null) {
      // TODO: inform user that location is not available
      return null;
    }

    await _handleLocation(locationData!.latitude!, locationData.longitude!);
    return _location;
  }

  void _selectOnMap() async {
    final currentLocation = await _getCurrentLocation();

    if (!mounted) return;

    final manualPickedLocation = await Navigator.of(context).push<LatLng>(
      CupertinoPageRoute(
        builder: (context) => MapPage(location: currentLocation),
      ),
    );

    if (!mounted) return;
    if (manualPickedLocation == null) return;

    _handleLocation(
        manualPickedLocation.latitude, manualPickedLocation.longitude);
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

  /// Returns the preview content of the location
  /// - If the location is being fetched, it shows a loading indicator
  /// - If the location is picked, it shows a static map of the location
  /// - If the location is not picked, it returns an empty container
  Widget _previewContent() {
    if (_isGettingLocation) {
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    }

    // Location is picked
    if (_location != null) {
      return Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Image.network(
          _geocodingService.getStaticMapUrl(_location!),
          fit: BoxFit.cover,
          width: 50,
          height: 50,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
