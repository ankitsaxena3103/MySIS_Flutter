import 'package:flutter/material.dart';

class Languages {
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('hi', 'IN'), // Hindi
    Locale('kn', 'IN'), // Kannada
    Locale('te', 'IN'), // Telugu
    Locale('ta', 'IN'), // tamil
    Locale('mr', 'IN'), // Marathi
    // Add more locales as needed
  ];

  static const Locale defaultLocale = Locale('en', 'US');
}
