import 'package:shared_preferences/shared_preferences.dart';

///Bkav HoangLD class dùng chung SharedPreferences
class SharedPrefs {
  static Future<SharedPreferences> get _createReferences async =>
      _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> instance() async {
    return await _createReferences;
  }
/*  static late final SharedPreferences instance;

  static Future<SharedPreferences> init() async =>
      instance = await SharedPreferences.getInstance();*/
}