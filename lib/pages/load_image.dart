import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:eat_neat/models/helper/theme.dart';
import 'package:eat_neat/models/image_recognition/camera_singleton.dart';
import 'package:eat_neat/models/image_recognition/google_cv.dart';
import 'package:eat_neat/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

class UserImage {
  Uint8List imgBytes;
  String? imgType;
  DetectionType responseType;

  UserImage(this.imgBytes, this.imgType, this.responseType);
}

class QueryPhoto extends StatefulWidget {
  const QueryPhoto({super.key});

  @override
  State<QueryPhoto> createState() => _QueryPhotoState();
}

class _QueryPhotoState extends State<QueryPhoto> with WidgetsBindingObserver {
  Uint8List? _imageData;
  CameraController? _controller;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    CameraDescription? cameraDesc = CameraSingleton.instance.getCamera();
    if (cameraDesc != null) {
      _controller = CameraController(cameraDesc, ResolutionPreset.high, imageFormatGroup: Platform.isIOS ? ImageFormatGroup.bgra8888 : ImageFormatGroup.yuv420);
      _controller!.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
      _controller!.initialize();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera with same properties
      _controller = CameraController(cameraController.description, ResolutionPreset.high,
          imageFormatGroup: Platform.isIOS ? ImageFormatGroup.bgra8888 : ImageFormatGroup.yuv420);
      _controller!.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
      _controller!.initialize();
    }
  }

  /// Take a picture with the camera. Saves image route to imagePath.
  Future<void> takePicture(CameraController controller) async {
    // Get a camera
    XFile image = await controller.takePicture();
    _imageData = await image.readAsBytes();
    setState(() {
      _imagePath = image.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    ImagePreference args = ImagePreference("", DetectionType.food);
    if (ModalRoute.of(context)!.settings.arguments != null) {
      args = ModalRoute.of(context)!.settings.arguments as ImagePreference;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(args.title, style: const TextStyle(fontSize: 14)),
        backgroundColor: Colors.blueGrey,
      ),
      body: Stack(children: [
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 120,
            child: () {
              if (_imagePath != null) {
                return Image.file(File(_imagePath!));
              }

              if (_controller != null) {
                if (_controller!.value.isInitialized) {
                  return _controller!.buildPreview();
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }

              return Padding(
                padding: const EdgeInsets.all(40.0),
                child: Center(child: Text("Can't Access Camera Object. Please provide proper permissions", style: TextThemes.emphasisText())),
              );
            }()),
        Positioned(
          bottom: 40,
          left: 40,
          right: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () async {
                    if (_controller != null) {
                      await takePicture(_controller!);
                    }
                  }),
              _imagePath != null
                  ? ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _imagePath = null;
                        });
                      },
                      child: const Text("Retake-Image"))
                  : const SizedBox(),
              _imagePath != null
                  ? ElevatedButton(
                      onPressed: () {
                        if (_imageData != null) {
                          // safety check, although not explicitly necessary
                          Navigator.of(context).pushNamed("/image/infer", arguments: UserImage(_imageData!, lookupMimeType(_imagePath!), args.type));
                        }
                      },
                      child: const Text("Continue"))
                  : const SizedBox(),
            ],
          ),
        ),
      ]),
    );
  }
}
