import 'package:train/main.dart';

class AppCache {
  final String _isLoggedIn = 'IS_LOGGED_IN';
  AppCache();

  Future<void> setIsLoggedIn(bool value) async {
    await sharedPref!.setBool(_isLoggedIn, value);
  }

  bool getIsLoggedIn() => sharedPref!.getBool(_isLoggedIn) ?? false;
}
