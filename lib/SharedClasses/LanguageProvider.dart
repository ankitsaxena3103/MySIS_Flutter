import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../CommonViews/Utility.dart';

class LanguageProvider with ChangeNotifier {

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> setLanguage(String languageCode, String countryCode) async {
    selectedLocale = '$languageCode-$countryCode';
    selectedLanguageCode = languageCode;
    await _saveLanguage();
    notifyListeners();
  }

  Future<void> _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('selectedLanguageCode');
    String? countryCode = prefs.getString('selectedCountryCode');
    if (languageCode != null && countryCode != null) {
      selectedLocale = '$languageCode-$countryCode';
      selectedLanguageCode = languageCode;
    }
  }

  Future<void> _saveLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedLanguageCode', selectedLanguageCode);
    prefs.setString('selectedCountryCode', selectedLocale ?? '');
  }
}
