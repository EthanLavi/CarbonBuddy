import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart';
import 'package:eat_neat/models/image_recognition/uid.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:gcloud/storage.dart';

String access_token =
    "ya29.a0Ael9sCMpiGG3eYWvYtQiiHRo9za4eW5iJMaGGmSc0_fdjuvEwg1OS9UhDreSDh4_Ud9USgs8HaCIgL3U3r_Wpo2QiR6TvUeH6sSdY9vDDCtFFKzYkm2Dmkap7y1AIxUYHs4fwRbGMudtrrZsb9CVVmzI0v9YyQt3S1wcaCgYKAb4SARISFQF4udJh_5xXOwe2YWo9A1Xz4-0MaQ0171";

enum DetectionType { text, food }

class GoogleAPIBridge {
  static GoogleAPIBridge? _instance;
  late auth.ServiceAccountCredentials _credentials;
  late auth.AutoRefreshingAuthClient _client;

  // Avoid self isntance
  GoogleAPIBridge._();

  Future<void> init() async {
    String json = await File('assets/secrets/eatneat-api-key.json').readAsString();
    _credentials = auth.ServiceAccountCredentials.fromJson(json);
    _client = await auth.clientViaServiceAccount(_credentials, Storage.SCOPES);
  }

  static GoogleAPIBridge get instance {
    _instance ??= GoogleAPIBridge._();
    return _instance!;
  }

  /// Will save the image to the cloud using the user's id
  Future<ObjectInfo> saveImage(Uint8List imgBytes, String? imgType) async {
    Storage storage = Storage(_client, "EatNeat");
    Bucket bucket = storage.bucket("image_upload_user");

    return await bucket.writeBytes(
      "${UIDManager.instance.userID}.png",
      imgBytes,
      metadata: ObjectMetadata(contentType: imgType),
    );
  }

  Future<List<String>> runInference(DetectionType type) async {
    Response rep = await post(
      Uri.parse("https://vision.googleapis.com/v1/images:annotate"),
      headers: {
        'Authorization': 'Bearer $access_token',
        'x-goog-user-project': 'eatneat-382419',
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: {
        "requests": [
          {
            "image": {
              "source": {"imageUri": "gs://eatneatdata/${UIDManager.instance.userID}.jpg"}
            },
            "features": [
              {"type": type == DetectionType.text ? "TEXT_DETECTION" : "LABEL_DETECTION"}
            ]
          }
        ]
      },
    );

    Map<String, dynamic> body = rep.body as Map<String, dynamic>;

    print(body);

    if (type == DetectionType.text) {
      String data = "";
      try {
        data = body['responses']['fullTextAnnotation']['text'];
      } on Error {
        return [];
      }

      return data.split(RegExp("\\W"));
    } else {
      List<String> data = [];
      try {
        for(Map<String, dynamic> e in body['responses']['labelAnnotations']){
          data.add(e['description']);
        }
      } on Error {
        return [];
      }

      return data;
    }
  }
}
