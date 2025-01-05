import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mysis/CommonViews/Utility.dart';
class ThemeProvider with ChangeNotifier {
  late ThemeData _themeData;

  ThemeProvider() {
    // Initialize theme based on saved preference or default to light theme
    _themeData = ThemeData.light();
    _loadTheme();
  }

  ThemeData get themeData => _themeData;

  void toggleTheme() {
    _themeData = _themeData.brightness == Brightness.light
        ? ThemeData.dark()
        : ThemeData.light();

    _saveTheme();
    notifyListeners();
  }
  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    isDarkMode = isDarkTheme;
    if (isDarkTheme) {
      _themeData = ThemeData.dark();
    } else {
      _themeData = ThemeData.light(); // Ensure light theme is set if not dark
    }
    notifyListeners(); // Notify listeners after loading the theme
  }


  Future<void> _loadTheme1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    isDarkMode = isDarkTheme;
    if (isDarkTheme) {
      _themeData = ThemeData.dark();
    }
  }

  Future<void> _saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkTheme = _themeData.brightness == Brightness.dark;
    isDarkMode = isDarkTheme;
    prefs.setBool('isDarkTheme', isDarkTheme);
  }

}
