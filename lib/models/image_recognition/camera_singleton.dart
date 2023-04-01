import 'package:camera/camera.dart';

class CameraSingleton {
  static CameraSingleton? _instance;
  // Avoid self isntance
  CameraSingleton._();
  
  // Camera object
  List<CameraDescription> _camera = [];

  CameraDescription? getCamera(){
    return _camera.first;
  }

  set camera(List<CameraDescription> values){
    if (_camera.isEmpty) _camera = values;
  }

  static CameraSingleton get instance{
    _instance ??= CameraSingleton._();
    return _instance!;
   }
}