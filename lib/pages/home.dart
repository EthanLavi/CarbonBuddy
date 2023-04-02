import 'dart:html';

import 'package:eat_neat/models/helper/theme.dart';
import 'package:eat_neat/models/image_recognition/google_cv.dart';
import 'package:eat_neat/models/image_recognition/uid.dart';
import 'package:eat_neat/pages/dish_input.dart';
import 'package:eat_neat/pages/recipe_input.dart';
import 'package:flutter/material.dart';
import 'package:eat_neat/models/image_recognition/camera_singleton.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePreference {
  String title;
  DetectionType type;
  ImagePreference(this.title, this.type);
}

class SplashHome extends StatelessWidget {
  const SplashHome({super.key});

  Future<List> _processingData() {
    return Future.wait([
      CameraSingleton.instance.init(),
      GoogleAPIBridge.instance.init(),
      UIDManager.instance.init(),
      Permission.camera.request(),
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
            return Stack(children: [
              Positioned(
                  top: 59,
                  bottom: 34,
                  left: 10,
                  right: 10,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Welcome!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 50, fontFamily: "SignPainter"),
                        ),
                        const SizedBox(height: 25),
                        Column(children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed("/image",
                                  arguments: ImagePreference(
                                      "Take a picture of your meal",
                                      DetectionType.food));
                            },
                            child: Container(
                              height: 100,
                              width: 350,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: const DecorationImage(
                                    image:
                                        AssetImage("assets/images/burger.jpg"),
                                    fit: BoxFit.cover),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.15),
                                    spreadRadius: 5,
                                    blurRadius: 5,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Center(
                                  child: Container(
                                      padding: const EdgeInsets.all(7.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white60),
                                      child: const Text(
                                        "Use a Picture of Food",
                                        style: TextStyle(fontSize: 24),
                                      ))),
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed("/image",
                                  arguments: ImagePreference(
                                      "Take a picture of any ingredient list",
                                      DetectionType.text));
                            },
                            child: Container(
                              height: 100,
                              width: 350,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: const DecorationImage(
                                      image: AssetImage(
                                          "assets/images/nutrition.jpeg"),
                                      fit: BoxFit.cover),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.15),
                                      spreadRadius: 5,
                                      blurRadius: 5,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ]),
                              child: Center(
                                  child: Container(
                                      padding: const EdgeInsets.all(7.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white60),
                                      child: const Text(
                                        "Use Nutrition Facts",
                                        style: TextStyle(fontSize: 24),
                                      ))),
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed("/recipe/input",
                                  arguments: DetectionType.text);
                            },
                            child: Container(
                              height: 100,
                              width: 350,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: const DecorationImage(
                                      image: AssetImage(
                                          "assets/images/shopping-list.jpg"),
                                      fit: BoxFit.cover),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.15),
                                      spreadRadius: 5,
                                      blurRadius: 5,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ]),
                              child: Center(
                                  child: Container(
                                      padding: const EdgeInsets.all(7.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.black12),
                                      child: const Text(
                                        "Copy & Paste a Recipe",
                                        style: TextStyle(fontSize: 24),
                                      ))),
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed("/dish/input",
                                  arguments: DetectionType.text);
                            },
                            child: Container(
                              height: 100,
                              width: 350,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: const DecorationImage(
                                      image: AssetImage(
                                          "assets/images/plate.jpeg"),
                                      fit: BoxFit.cover),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.15),
                                      spreadRadius: 5,
                                      blurRadius: 5,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ]),
                              child: Center(
                                  child: Container(
                                      padding: const EdgeInsets.all(7.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white60),
                                      child: const Text(
                                        "Input a Recipe Name",
                                        style: TextStyle(fontSize: 24),
                                      ))),
                            ),
                          )
                        ])
                      ]))
            ]);
          }
        },
      ),
    );
  }
}
