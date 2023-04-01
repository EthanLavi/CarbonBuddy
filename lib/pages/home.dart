import 'package:eat_neat/models/helper/theme.dart';
import 'package:eat_neat/models/image_recognition/google_cv.dart';
import 'package:eat_neat/models/image_recognition/uid.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:eat_neat/models/image_recognition/camera_singleton.dart';

class SplashHome extends StatelessWidget {
  const SplashHome({super.key});

  Future<List> _processingData() {
    return Future.wait([
      Future.delayed(const Duration(), () async {
        CameraSingleton.instance.camera = await availableCameras();
      }),
      GoogleAPIBridge.instance.init(),
      UIDManager.instance.init(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _processingData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Stack(children: [
              Positioned(
                  top: 40,
                  left: 40,
                  right: 40,
                  child: Text(
                    "Loading...",
                    style: TextThemes.emphasisText(),
                  )),
              const Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Center(child: CircularProgressIndicator()),
              )
            ]);
          } else {
            return Stack(children: const []);
          }
        },
      ),
    );
  }
}
