import 'package:flutter/cupertino.dart';
import 'package:my_places/models/place.dart';
import 'package:my_places/pages/add_place.dart';
import 'package:my_places/pages/place_detail.dart';

/// A widget that displays a list of places.
///
/// This widget takes a list of [Place] objects and displays them in a
/// scrollable list. Each place is represented by a widget that shows
/// its details.
class PlacesList extends StatelessWidget {
  final List<Place> places;

  /// Creates a [PlacesList] widget.
  ///
  /// The [places] parameter must not be null and should contain the
  /// list of places to be displayed.
  const PlacesList({
    super.key,
    required this.places,
  });

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(CupertinoIcons.map_pin_ellipse, size: 64),
          const SizedBox(height: 16),
          const Text('No places yet.',
              style: TextStyle(color: CupertinoColors.secondaryLabel)),
          const SizedBox(height: 8),
          CupertinoButton(
            child: const Text('Start adding'),
            onPressed: () {
              Navigator.of(context).push(
                CupertinoModalPopupRoute(
                  builder: (context) => const AddPlacePage(),
                ),
              );
            },
          )
        ],
      );
    }
    return CupertinoListSection.insetGrouped(
      children: places.map((place) {
        // Remove the first word from the address to make it shorter.
        final address = place.location.address.split(' ').skip(1).join(' ');
        return CupertinoListTile.notched(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          leadingSize: 50,
          leading: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
            child: Image.file(
              place.image,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(place.name),
          subtitle: Text(address),
          onTap: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                title: place.name,
                builder: (context) => PlaceDetailScreen(place: place),
              ),
            );
          },
          trailing: const CupertinoListTileChevron(),
        );
      }).toList(),
    );
  }
}
