import 'package:flutter/cupertino.dart';
import 'dark_theme_preference.dart';

class DarkThemeProvider with ChangeNotifier {
  final DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = false;

  bool get isDarkTheme => _darkTheme;

  set isDarkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}
