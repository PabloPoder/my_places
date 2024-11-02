import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_places/models/place.dart';
import 'package:my_places/pages/map.dart';
import 'package:my_places/providers/user_places.dart';
import 'package:my_places/services/geocoding_service.dart';

/// A screen that displays the details of a specific place.
///
/// This screen shows the name and other details of the [Place] object
/// passed to it. It uses a [CupertinoPageScaffold] to provide a
/// consistent iOS look and feel.
class PlaceDetailScreen extends ConsumerWidget {
  final Place place;
  final _geocodingService = GeocodingService();

  /// Creates a [PlaceDetailScreen] widget.
  ///
  /// The [place] parameter must not be null and should contain the
  /// details of the place to be displayed.
  PlaceDetailScreen({super.key, required this.place});

  /// Handles the deletion of the place.
  /// This method shows a dialog to confirm the deletion of the place.
  /// If the user confirms the deletion, the place is removed from the
  /// user's list of places and the screen is popped.
  ///
  /// Parameters:
  /// The [context] parameter is the [BuildContext] of the screen.
  /// The [ref] parameter is the [WidgetRef] object that provides access
  void _handleDelete(BuildContext context, WidgetRef ref) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Delete Place"),
        content: const Text("Are you sure you want to delete this place?"),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(userPlacesProvider.notifier).removePlace(place);
              Navigator.of(context).pop();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: true,
        automaticallyImplyMiddle: true,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => _handleDelete(context, ref),
          child: const Icon(CupertinoIcons.delete),
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            Image.file(
              place.image,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.05),
                      Colors.black.withOpacity(0.02),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          /// Navigates to the [MapPage] screen to show the location
                          /// of the place on a map.
                          /// The [MapPage] screen is not interactive in this case
                          /// because the [isSelecting] parameter is set to false.
                          CupertinoPageRoute(
                            title: "Your Location",
                            builder: (context) => MapPage(
                              location: place.location,
                              isSelecting: false,
                            ),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                            _geocodingService.getStaticMapUrl(place.location)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      textAlign: TextAlign.center,
                      place.description,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: CupertinoColors.extraLightBackgroundGray),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      textAlign: TextAlign.center,
                      // TODO Remove: place.location.address.split(' ').skip(1).join(' '),
                      place.location.address,
                      style: const TextStyle(
                          fontSize: 18, color: CupertinoColors.systemGrey),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      textAlign: TextAlign.center,
                      place.getFormattedDate(),
                      style: const TextStyle(
                          fontSize: 14, color: CupertinoColors.systemGrey),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
