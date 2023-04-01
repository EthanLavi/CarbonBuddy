import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:eat_neat/models/helper/theme.dart';
import 'package:eat_neat/models/image_recognition/camera_singleton.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

class UserImage {
  Uint8List imgBytes;
  String? imgType;

  UserImage(this.imgBytes, this.imgType);
}

class QueryPhoto extends StatefulWidget {
  const QueryPhoto({super.key});

  @override
  State<QueryPhoto> createState() => _QueryPhotoState();
}

class _QueryPhotoState extends State<QueryPhoto> {
  Uint8List? _imageData;
  CameraController? _controller;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    CameraDescription? cameraDesc = CameraSingleton.instance.getCamera();
    if (cameraDesc != null) {
      _controller = CameraController(cameraDesc, ResolutionPreset.ultraHigh);
    }
  }

  /// Take a picture with the camera. Saves image route to imagePath.
  Future<void> takePicture(CameraController controller) async {
    await controller.initialize();

    // Get a camera
    XFile image = await controller.takePicture();
    _imageData = await image.readAsBytes();
    setState(() {
      _imagePath = image.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(children: [
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: () {
              if (_imagePath != null) {
                return Image.file(File(_imagePath!));
              }
              if (_controller != null) {
                return CameraPreview(_controller!);
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
            children: [
              IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () async {
                    if (_controller != null) {
                      await takePicture(_controller!);
                    }
                  }),
              _imagePath != null
                  ? FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          _imagePath = "";
                        });
                      },
                      child: const Text("Retake-Image"))
                  : const SizedBox(),
              _imagePath != null
                  ? FloatingActionButton(
                      onPressed: () {
                        if (_imageData != null) { // safety check, although not explicitly necessary
                          Navigator.of(context).pushNamed("/image/infer", arguments: UserImage(_imageData!, lookupMimeType(_imagePath!)));
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
