import 'package:eat_neat/models/helper/future_helper.dart';
import 'package:eat_neat/models/image_recognition/google_cv.dart';
import 'package:eat_neat/models/sustainability_query/sus.dart';
import 'package:eat_neat/pages/load_image.dart';
import 'package:flutter/material.dart';

class InferencePage extends StatelessWidget {
  const InferencePage({super.key});

  Future<List<String>> runningInference(UserImage i) async {
    await GoogleAPIBridge.instance.saveImage(i.imgBytes, i.imgType);
    await Future.delayed(const Duration(seconds: 5), () {});
    return await GoogleAPIBridge.instance.runInference(i.responseType);
  }

  @override
  Widget build(BuildContext context) {
    UserImage args = ModalRoute.of(context)!.settings.arguments as UserImage;
    return Scaffold(
        appBar: AppBar(title: const Text("Computing..."), backgroundColor: Colors.blueGrey),
        body: waitWhileQuerying<List<String>>(
            future: runningInference(args),
            child: (List<String> data) {
              print(data);
              return waitWhileQuerying<FoodRating>(
                  future: FoodRating.getRatingFromList(data),
                  child: (FoodRating rating) {
                    return Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed("/recipe", arguments: rating);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(22.0),
                          child: Text("Continue", style: TextStyle(fontSize: 30)),
                        ),
                      ),
                    );
                  });
            }));
  }
}
