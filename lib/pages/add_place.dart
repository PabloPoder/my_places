import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_places/models/place.dart';

import 'package:my_places/providers/user_places.dart';
import 'package:my_places/widgets/image_input.dart';

class AddPlacePage extends ConsumerStatefulWidget {
  const AddPlacePage({super.key});

  @override
  ConsumerState<AddPlacePage> createState() => _AddPlacePageState();
}

class _AddPlacePageState extends ConsumerState<AddPlacePage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  /// Save the place using the [UserPlacesNotifier] provider
  void _savePlace() {
    final name = _nameController.text;
    final description = _descriptionController.text;

    if (name.isEmpty || description.isEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Error'),
            content: const Text('Please fill in all fields'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    final place = Place(name: name, description: description);
    ref.read(userPlacesProvider.notifier).addPlace(place);

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    /// Dispose the controllers to avoid memory leaks
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: true,
        middle: const Text('Add Place'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _savePlace,
          child: const Text('Save'),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              CupertinoFormSection(
                header: const Text('Place Details'),
                children: <Widget>[
                  CupertinoFormRow(
                    prefix: const Text('Name'),
                    child: CupertinoTextFormFieldRow(
                      controller: _nameController,
                      placeholder: 'Enter place name',
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                  CupertinoFormRow(
                    prefix: const Text('Description'),
                    child: CupertinoTextFormFieldRow(
                      controller: _descriptionController,
                      textCapitalization: TextCapitalization.sentences,
                      placeholder: 'Enter place description',
                    ),
                  ),
                  ImageInput(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
