import 'package:eat_neat/models/image_recognition/google_cv.dart';
import 'package:eat_neat/models/sustainability_query/sus.dart';
import 'package:eat_neat/pages/load_image.dart';
import 'package:flutter/material.dart';

class InferencePage extends StatefulWidget {
  const InferencePage({super.key});

  @override
  State<InferencePage> createState() => _InferencePageState();
}

class _InferencePageState extends State<InferencePage> {
  bool loadingInference = false;

  Future<List<String>> runningInference(UserImage i) async {
    await GoogleAPIBridge.instance.saveImage(i.imgBytes, i.imgType);
    await Future.delayed(const Duration(seconds: 10), () {}); // wait 10 seconds for the image to be in the 
    return await GoogleAPIBridge.instance.runInference(i.responseType);
  }

  Future<List<String>> runQuickInference(UserImage i) async {
    return await GoogleAPIBridge.instance.runQuickInference(i.imgBytes, i.responseType);
  }

  @override
  Widget build(BuildContext context) {
    UserImage args = ModalRoute.of(context)!.settings.arguments as UserImage;
    return Scaffold(
        appBar: AppBar(
            title: const Text("Computing..."),
            backgroundColor: Colors.blueGrey,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                if (!loadingInference) {
                  Navigator.pop(context);
                }
              },
            )),
        body: Center(
          child: !loadingInference
              ? ElevatedButton(
                  onPressed: () async {
                    if (loadingInference) return;
                    setState(() {
                      loadingInference = true;
                    });
                    NavigatorState state = Navigator.of(context);
                    List<String> data = await runQuickInference(args);
                    print(data);
                    FoodRating rating = await FoodRating.getRatingFromList(data);
                    print(rating.ingredients);
                    setState(() {
                      loadingInference = false;
                    });
                    state.pushNamed("/recipe", arguments: rating);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(22.0),
                    child: Text("Analyze Image", style: TextStyle(fontSize: 30)),
                  ),
                )
              : const CircularProgressIndicator(),
        ));
  }
}
