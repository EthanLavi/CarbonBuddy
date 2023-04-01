import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class QueryPhoto extends StatelessWidget {
  const QueryPhoto({super.key});

  Future<XFile> takePicture() async {
    // Get a camera
    CameraDescription camera = (await availableCameras()).first;
    CameraController _controller = CameraController(camera, ResolutionPreset.ultraHigh);
    await _controller.initialize();
    return await _controller.takePicture();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
