import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_places/pages/add_place.dart';
import 'package:my_places/providers/user_places.dart';
import 'package:my_places/widgets/places_list.dart';

class PlacesPage extends ConsumerStatefulWidget {
  const PlacesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PlacesPageState();
  }
}

class _PlacesPageState extends ConsumerState<PlacesPage> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(userPlacesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(userPlacesProvider).places;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.secondarySystemBackground,
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
        body: FutureBuilder(
          future: _placesFuture,
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const CupertinoActivityIndicator()
                  : PlacesList(places: userPlaces),
        ),
      ),
    );
  }
}
