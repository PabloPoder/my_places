import 'package:flutter/cupertino.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key});

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  void _takePicture() {}

  @override
  Widget build(BuildContext context) {
    return CupertinoFormRow(
      prefix: const Text('Image'),
      child: CupertinoButton(
        child: const Text('Upload Image'),
        onPressed: () {},
      ),
    );
  }
}
