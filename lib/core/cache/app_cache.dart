import 'package:train/main.dart';

class AppCache {
  final String _isLoggedIn = 'IS_LOGGED_IN';
  final String _userId = 'USER_ID';
  AppCache();
  // IsLoggedIn
  Future<void> setIsLoggedIn(bool value) async {
    await sharedPref!.setBool(_isLoggedIn, value);
  }

  bool getIsLoggedIn() => sharedPref!.getBool(_isLoggedIn) ?? false;
  // UserId
  Future<void> setUserId(String value) async {
    await sharedPref!.setString(_userId, value);
  }

  String getUserId() => sharedPref!.getString(_userId) ?? "";
}
