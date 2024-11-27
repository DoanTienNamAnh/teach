import 'package:camera/camera.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:demo/screens/camera/app_camera.dart';
import 'package:demo/screens/camera/image_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DocumentScanningScreen extends StatefulWidget {
  const DocumentScanningScreen(
      {super.key,
        required this.appbarTitle,
        this.title,
        this.content});

  final String appbarTitle;
  final String? title;
  final String? content;

  @override
  State<DocumentScanningScreen> createState() => _DocumentScanningScreenState();
}

class _DocumentScanningScreenState extends State<DocumentScanningScreen> {
  final CropController _controller = CropController();

  XFile? _image;

  Uint8List? _imageCropped;

  Rect? _rect;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.appbarTitle,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.help_outline,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _image?.readAsBytes(),
        builder: (context, snapShot) => Stack(
          children: [
            if (snapShot.data != null)
              SafeArea(
                child: Crop(
                  key: ObjectKey(snapShot.data!),
                  image: snapShot.data!,
                  controller: _controller,
                  onCropped: (image) {
                    _imageCropped = image;
                    if(_imageCropped != null) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImagePreview(image: _imageCropped!,)));
                    }
                  },
                  initialRectBuilder: (rect, rect2) => _rect!,
                  baseColor: Colors.black,
                  maskColor: Colors.black.withOpacity(0.8),
                  radius: 16,
                  progressIndicator: const CircularProgressIndicator(),
                  onStatusChanged: (status) {
                    if (status == CropStatus.ready && _imageCropped == null) {
                      _controller.crop();
                    }
                  },
                  cornerDotBuilder: (size, alignment) => const SizedBox(),
                ),
              ),
            AppCamera(
              overlayBuilder: (context, controller) => DocumentCameraOverlay(
                cameraSize: controller.value.previewSize ?? Size.zero,
                title: widget.title,
                content: widget.content,
                onTakePhoto: (Rect rect) async {
                  var image = await controller.takePicture();
                  _imageCropped = null;
                  setState(() {
                    _image = image;
                    _rect = rect;
                  });
                  // controller.pausePreview();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


