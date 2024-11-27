import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImagePreview extends StatefulWidget {
  const ImagePreview({super.key, required this.image});

  final Uint8List image;

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:
          Image.memory(widget.image)
    );
  }
}
