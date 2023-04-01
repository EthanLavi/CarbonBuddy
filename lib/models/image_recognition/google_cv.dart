import 'dart:io';
import 'dart:typed_data';

import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:gcloud/storage.dart';

class GoogleAPIBridge {
  static GoogleAPIBridge? _instance;
  late auth.ServiceAccountCredentials _credentials;
  late auth.AutoRefreshingAuthClient _client;

  // Avoid self isntance
  GoogleAPIBridge._();

  Future<void> init() async {
    String json = await File('my-project.json').readAsString();
    _credentials = auth.ServiceAccountCredentials.fromJson(json);
    _client = await auth.clientViaServiceAccount(_credentials, Storage.SCOPES);
  }

  static GoogleAPIBridge get instance {
    _instance ??= GoogleAPIBridge._();
    return _instance!;
  }

  Future<ObjectInfo> saveImage(String name, Uint8List imgBytes) {
    Storage storage = Storage(_client, "EatNeat");
    storage.bucket("image_upload_user");
  }
}
