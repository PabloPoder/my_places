import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_places/models/place.dart';

/// A page widget that displays a Google Map for viewing or selecting locations.
///
/// This widget provides two main functionalities:
/// 1. Viewing a specific location on the map
/// 2. Selecting a new location by tapping on the map
class MapPage extends StatefulWidget {
  /// The initial location to display on the map
  final PlaceLocation location;

  /// Whether the map is in selection mode
  final bool isSelecting;

  /// Creates a MapPage with optional location and selection mode
  ///
  /// Default location is set to Google HQ coordinates:
  /// latitude: 37.422, longitude: -122.084
  /// Default selection mode is set to true
  const MapPage({
    super.key,
    this.location = const PlaceLocation(
      latitude: 37.422,
      longitude: -122.084,
      address: '',
    ),
    this.isSelecting = true,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  /// Stores the location picked by user when in selection mode
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: true,
        // Navigation bar with dynamic title based on mode
        middle: widget.isSelecting
            ? const Text('Select on Map')
            : const Text('Place Location'),
        // Save button only shown in selection mode
        trailing: widget.isSelecting
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.archivebox_fill),
                onPressed: () {
                  Navigator.of(context).pop(_pickedLocation);
                },
              )
            : null,
      ),
      child: GoogleMap(
        // Enable location selection only in selection mode
        onTap: (position) {
          if (widget.isSelecting) {
            return setState(() {
              _pickedLocation = position;
            });
          }
        },
        // Initial map view configuration
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.location.latitude,
            widget.location.longitude,
          ),
          zoom: 16,
        ),
        // Display marker for selected or initial location
        markers: _pickedLocation == null && widget.isSelecting
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('m1'),
                  position: _pickedLocation ??
                      LatLng(
                        widget.location.latitude,
                        widget.location.longitude,
                      ),
                ),
              },
      ),
    );
  }
}
