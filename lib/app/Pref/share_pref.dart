import 'package:shared_preferences/shared_preferences.dart';

class SharePrefService {
  // static late SharedPreferences pref;
  //
  // Future<void> init() async {
  //   pref = await SharedPreferences.getInstance();
  // }
  //
  // static setIntValue({required String key, required int value}) {
  //   return pref.setInt(key, value);
  // }
  //
  // static getIntValue({required String key}) {
  //   return pref.getInt(key);
  // }

  Future addIntToSF({
    required String key,
    required int value,
  }) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    final isSaved = pref.setInt(key, value);

    //print(isSaved);
  }

  Future addStringToSF({
    required String key,
    required String value,
  }) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    final isSaved = pref.setString(key, value);

    //print(isSaved);
  }

  Future<int?> getIntToSF({
    required String key,
  }) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    int? value = pref.getInt(key);

    return value;
  }

  Future<String> getStringToSF({
    required String key,
  }) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    String value = pref.getString(key) ?? "";

    return value;
  }

  Future removeIntToSF({
    required String key,
  }) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    int? value = pref.getInt(key);

    if (value != null) {
      await pref.remove(key);
      print(value);
    }

    return value;
  }
}
