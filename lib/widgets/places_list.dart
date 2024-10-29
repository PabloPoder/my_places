import 'package:flutter/cupertino.dart';
import 'package:my_places/models/place.dart';
import 'package:my_places/pages/place_detail.dart';

class PlacesList extends StatelessWidget {
  final List<Place> places;
  const PlacesList({
    super.key,
    required this.places,
  });

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return const Center(
        child: Text('No places added yet, start adding some!'),
      );
    }
    return CupertinoListSection.insetGrouped(
      children: places.map((place) {
        return CupertinoListTile(
          // leading: CircleAvatar(
          //   backgroundImage: FileImage(place.image),
          // ),
          // Image.file(
          //   place.image,
          //   width: 50,
          //   height: 50,
          //   fit: BoxFit.cover,
          // ),
          title: Text(place.name),
          subtitle: Text(place.description),
          onTap: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                title: place.name,
                builder: (context) => PlaceDetailScreen(place: place),
              ),
            );
          },
          trailing: CupertinoListTileChevron(),
        );
      }).toList(),
    );
  }
}
