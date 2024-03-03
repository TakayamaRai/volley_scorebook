import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static SharedPreferences prefs;

  static Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveBoolLanguageType(bool value) async{
    await prefs.setBool('languageType', value);
  }

  static bool loadBoolLanguageType() {
    return prefs.getBool('languageType') ?? true;
  }

}