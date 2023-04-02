import 'package:camera/camera.dart';

class CameraSingleton {
  static CameraSingleton? _instance;
  // Avoid self isntance
  CameraSingleton._();

  // Camera object
  List<CameraDescription> _camera = [];

  Future<void> init() async {
    _camera = await availableCameras();
  }

  CameraDescription? getCamera() {
    return _camera.isEmpty ? null : _camera.first;
  }

  static CameraSingleton get instance {
    _instance ??= CameraSingleton._();
    return _instance!;
  }
}
