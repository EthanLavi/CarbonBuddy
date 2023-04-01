import 'package:eat_neat/models/helper/theme.dart';
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
                              fontSize: 50,
                              fontStyle: FontStyle.italic,
                              fontFamily: "SignPainter"),
                        ),
                        const SizedBox(height: 25),
                        Column(children: [
                          Container(
                            height: 100,
                            width: 350,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: const DecorationImage(
                                    image: AssetImage("images/burger.jpg"),
                                    fit: BoxFit.cover)),
                            child: Center(
                                child: Container(
                                    padding: const EdgeInsets.all(7.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white60),
                                    child: const Text(
                                      "Picture of Food",
                                      style: TextStyle(fontSize: 24),
                                    ))),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 100,
                            width: 350,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: const DecorationImage(
                                    image: AssetImage("images/nutrition.jpeg"),
                                    fit: BoxFit.cover)),
                            child: Center(
                                child: Container(
                                    padding: const EdgeInsets.all(7.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white60),
                                    child: const Text(
                                      "Picture of Nutrition Facts",
                                      style: TextStyle(fontSize: 24),
                                    ))),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 100,
                            width: 350,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: const DecorationImage(
                                    image:
                                        AssetImage("images/shopping-list.jpg"),
                                    fit: BoxFit.cover)),
                            child: Center(
                                child: Container(
                                    padding: const EdgeInsets.all(7.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.black12),
                                    child: const Text(
                                      "Recipe",
                                      style: TextStyle(fontSize: 24),
                                    ))),
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
