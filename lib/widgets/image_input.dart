import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

/// A widget that allows the user to take a picture using the camera.
///
/// This widget provides a button to open the camera and take a picture.
/// Once a picture is taken, it displays the picture and calls the
/// [onSelectImage] callback with the selected image file.
class ImageInput extends StatefulWidget {
  final void Function(File image) onSelectImage;

  /// Creates an [ImageInput] widget.
  ///
  /// The [onSelectImage] parameter must not be null.
  const ImageInput({super.key, required this.onSelectImage});

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  /// The selected image file.
  File? _selectedImage;

  /// Opens the camera to take a picture.
  ///
  /// If a picture is taken, it sets the [_selectedImage] to the taken picture
  /// and calls the [onSelectImage] callback with the selected image file.
  /// Otherwise, it does nothing.
  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 700);

    if (pickedImage == null) return;

    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    widget.onSelectImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoFormRow(
      prefix: const Text('Image'),
      child: _buildContent(),
    );
  }

  /// Builds the content of the form row.
  ///
  /// If an image is selected, it displays the image.
  /// Otherwise, it displays a button to take a picture.
  ///
  /// Returns a [Widget].
  Widget _buildContent() {
    if (_selectedImage != null) {
      return GestureDetector(
        onTap: _takePicture,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: Image.file(
            _selectedImage!,
            fit: BoxFit.cover,
            width: 50,
            height: 50,
          ),
        ),
      );
    } else {
      return CupertinoButton(
        onPressed: _takePicture,
        child: const Text('Take Picture'),
      );
    }
  }
}
