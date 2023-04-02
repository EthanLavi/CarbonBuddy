import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:gcloud/storage.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart';

import 'package:eat_neat/models/image_recognition/uid.dart';

enum DetectionType { text, food, recipe }

class GoogleAPIBridge {
  static GoogleAPIBridge? _instance;
  late auth.ServiceAccountCredentials _credentials;
  late auth.AutoRefreshingAuthClient _client;

  late auth.ServiceAccountCredentials _credentialsVision;
  late auth.AutoRefreshingAuthClient _clientVision;

  // Avoid self isntance
  GoogleAPIBridge._();

  Future<void> init() async {
    String jsonBucket = await rootBundle.loadString('assets/secrets/eatneat-api-key.json');
    String jsonVision = await rootBundle.loadString('assets/secrets/eatneat-vision-key.json');

    _credentials = auth.ServiceAccountCredentials.fromJson(jsonBucket);
    _client = await auth.clientViaServiceAccount(_credentials, Storage.SCOPES);

    _credentialsVision = auth.ServiceAccountCredentials.fromJson(jsonVision);
    _clientVision = await auth.clientViaServiceAccount(_credentialsVision, ["https://www.googleapis.com/auth/cloud-vision"]);
  }

  static GoogleAPIBridge get instance {
    _instance ??= GoogleAPIBridge._();
    return _instance!;
  }

  /// Will save the image to the cloud using the user's id
  Future<ObjectInfo> saveImage(Uint8List imgBytes, String? imgType) async {
    Storage storage = Storage(_client, "EatNeat");
    Bucket bucket = storage.bucket("eatneatdata");

    return await bucket.writeBytes(
      "${UIDManager.instance.userID}.jpeg",
      imgBytes,
      metadata: ObjectMetadata(contentType: imgType),
    );
  }

  Future<List<String>> runInference(DetectionType type) async {
    if (type == DetectionType.recipe) return [];

    Response rep = await _clientVision.post(
      Uri.parse("https://vision.googleapis.com/v1/images:annotate"),
      headers: {
        'x-goog-user-project': 'eatneat-382419',
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: jsonEncode({
        "requests": [
          {
            "image": {
              "source": {"imageUri": "https://storage.googleapis.com/eatneatdata/${UIDManager.instance.userID}.jpeg"}
            },
            "features": [
              {"type": type == DetectionType.text ? "TEXT_DETECTION" : "LABEL_DETECTION"}
            ]
          }
        ]
      }),
    );

    Map<String, dynamic> body = jsonDecode(rep.body) as Map<String, dynamic>;

    if (type == DetectionType.text) {
      String data = "";
      try {
        data = body['responses'][0]['textAnnotations'][0]['description'];
      } on Error {
        return [];
      }
      data = data.toLowerCase();
      List<String> tokens = data.split(RegExp("\\W"));
      tokens.removeWhere((element) => element == "" || element == " ");
      return tokens;
    } else {
      List<String> data = [];
      try {
        for (Map<String, dynamic> e in body['responses'][0]['labelAnnotations']) {
          data.add(e['description']);
        }
      } on Error {
        return [];
      }

      return data;
    }
  }
}
