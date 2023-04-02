import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _uidKey = "deviceId";

class UIDManager {
  static UIDManager? _instance;

  late SharedPreferences _prefs;
  late String userID;

  // Avoid self instance
  UIDManager._();

  static UIDManager get instance {
    _instance ??= UIDManager._();
    return _instance!;
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey(_uidKey)) {
      userID = _prefs.getString(_uidKey) ?? "";
    } else {
      userID = const Uuid().v4();
      _prefs.setString(_uidKey, userID);
    }
  }
}
