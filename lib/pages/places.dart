import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_places/pages/add_place.dart';
import 'package:my_places/providers/user_places.dart';
import 'package:my_places/widgets/places_list.dart';

class PlacesPage extends ConsumerWidget {
  const PlacesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPlaces = ref.watch(userPlacesProvider);

    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            CupertinoSliverNavigationBar(
              largeTitle: const Text('Places'),
              transitionBetweenRoutes: true,
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.add),
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoModalPopupRoute(
                      builder: (context) => const AddPlacePage(),
                    ),
                  );
                },
              ),
            ),
          ];
        },
        body: PlacesList(places: userPlaces),
      ),
    );
  }
}
