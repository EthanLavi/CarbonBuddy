import 'package:eat_neat/models/helper/future_helper.dart';
import 'package:eat_neat/models/image_recognition/google_cv.dart';
import 'package:eat_neat/pages/load_image.dart';
import 'package:flutter/material.dart';

class InferencePage extends StatelessWidget {
  const InferencePage({super.key});

  Future<List<String>> runningInference(UserImage i) async {
    await GoogleAPIBridge.instance.saveImage(i.imgBytes, i.imgType);
    return await GoogleAPIBridge.instance.runInference(DetectionType.food);
  }

  @override
  Widget build(BuildContext context) {
    UserImage args = ModalRoute.of(context)!.settings.arguments as UserImage;
    return Scaffold(
        appBar: AppBar(),
        body: waitWhileQuerying<List<String>>(
            future: runningInference(args),
            child: (List<String> data) {
              print(data);
              return Text("");
            }));
  }
}
