import 'package:camera/camera.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class AppCamera extends StatefulWidget {
  const AppCamera(
      {super.key, required this.overlayBuilder, this.cameraLensDirection});
  final Widget Function(BuildContext context, CameraController controller)
      overlayBuilder;
  final CameraLensDirection? cameraLensDirection;

  @override
  State<AppCamera> createState() => _AppCameraState();
}

class _AppCameraState extends State<AppCamera> {
  List<CameraDescription> cameras = [];
  CameraDescription? primaryCamera;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((data) async {
      final cameras = await availableCameras();
      setState(() {
        primaryCamera = cameras.firstWhereOrNull((element) =>
            widget.cameraLensDirection != null
                ? element.lensDirection == widget.cameraLensDirection
                : element.lensDirection == CameraLensDirection.external ||
                    element.lensDirection == CameraLensDirection.back ||
                    element.lensDirection == CameraLensDirection.front);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return primaryCamera == null
        ? const Center(
            child: Text('Cannot load camera'),
          )
        : AppCameraPreview(
            camera: primaryCamera!,
            overlayBuilder: (context, controller) =>
                widget.overlayBuilder.call(context, controller),
          );
  }
}

class AppCameraPreview extends StatefulWidget {
  final CameraDescription camera;
  final Widget Function(BuildContext context, CameraController controller)
      overlayBuilder;

  const AppCameraPreview(
      {super.key, required this.camera, required this.overlayBuilder});

  @override
  State<AppCameraPreview> createState() => _AppCameraPreviewState();
}

class _AppCameraPreviewState extends State<AppCameraPreview> {
  late final CameraController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.max,
    );
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller.setFlashMode(FlashMode.off);
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SafeArea(
      child: Container(
        color: Colors.black,
        child: Stack(
          children: [
            Center(
              child: CameraPreview(_controller),
            ),
            widget.overlayBuilder.call(context, _controller),
          ],
        ),
      ),
    );
  }
}

class HoleOverlayPainter extends CustomPainter {
  final Path Function(Size) pathBuilder;

  HoleOverlayPainter({
    required this.pathBuilder,
  });

  @override
  void paint(Canvas canvas, Size size) {
    {
      final paint = Paint()..color = Colors.black.withOpacity(0.8);
      canvas.drawPath(
        Path.combine(
          PathOperation.difference,
          Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
          pathBuilder(size),
        ),
        paint,
      );
    }
    {
      final strokePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.white;
      canvas.drawPath(
        pathBuilder(size),
        strokePaint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}



class DocumentCameraOverlay extends StatelessWidget {
  final Size cameraSize;
  final String? title;
  final String? content;
  final void Function(Rect rect) onTakePhoto;

  const DocumentCameraOverlay({
    super.key,
    required this.cameraSize,
    required this.onTakePhoto,
    this.title,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    late Offset offset;
    late Rect center;
    late double areaWidth;
    late double areaHeight;
    return SizedBox.fromSize(
      size: cameraSize,
      child: Stack(
        children: [
          CustomPaint(
            size: cameraSize,
            painter: HoleOverlayPainter(
              pathBuilder: (size) {
                offset = Offset(size.width * 0.5, size.height * 0.5);
                areaWidth = size.shortestSide * 0.8;
                areaHeight = size.shortestSide * 0.8 * 2 / 3;
                center = Rect.fromCenter(
                  center: offset,
                  width: areaWidth,
                  height: areaHeight,
                );
                return Path()
                  ..addRRect(
                    RRect.fromRectAndRadius(
                      center,
                      const Radius.circular(16),
                    ),
                  )
                  ..close();
              },
            ),
          ),
          if (title != null || content != null)
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Positioned(
                    top: 48 * (MediaQuery.of(context).size.width /
                        MediaQuery.of(context).size.height) / 375/812,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Visibility(
                        visible: title != null,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16),
                          child: Text(
                            title ?? '',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 90 * (MediaQuery.of(context).size.width /
                        MediaQuery.of(context).size.height) / 375/812,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16),
                      child: Text(
                        content!,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Positioned(
                      left: 0,
                      right: 0,
                      bottom: 100,
                      child: InkWell(
                        onTap: () {
                          onTakePhoto.call(center);
                        },
                        child: const Icon(Icons.photo_camera, size: 40, color: Colors.white,),
                      ))
                ],
              ),
            ),
        ],
      ),
    );
  }
}
