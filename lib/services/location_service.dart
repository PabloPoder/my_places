import 'package:location/location.dart';

class LocationService {
  /// Location plugin instance to get the location of the device
  final Location _location = Location();

  /// Check if the location service is enabled
  Future<bool> checkServiceEnabled() async {
    var serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
    }
    return serviceEnabled;
  }

  /// Check if the location permission is granted
  Future<bool> checkPermissionGranted() async {
    var permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
    }
    return permissionGranted == PermissionStatus.granted;
  }

  /// Get the current location of the device
  ///
  /// Returns:
  /// - [LocationData] if the location is available
  /// - `null` if the location is not available
  Future<LocationData?> getCurrentLocation() async {
    return await _location.getLocation();
  }
}
