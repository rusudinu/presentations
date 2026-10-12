import 'package:flutter/material.dart';

// The whole palette comes from one seed color, once for each brightness.
ColorScheme _scheme(Brightness b) =>
    ColorScheme.fromSeed(seedColor: const Color(0xFF3F51B5), brightness: b);

// Declared once, read everywhere through Theme.of(context).
ThemeData appTheme(Brightness b) => ThemeData(
  colorScheme: _scheme(b),
  // fontFamily: 'Inter' goes here once the font files are declared in pubspec.yaml.
  // Component themes: every AppBar, text field and filled button in the app.
  appBarTheme: const AppBarTheme(centerTitle: true),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
  filledButtonTheme: FilledButtonThemeData(
    // 48 high: the minimum tap target, set in one place.
    style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
  ),
);

// The user's choice of light, dark or system. An app saves this value: Lecture 9.
final themeMode = ValueNotifier<ThemeMode>(ThemeMode.system);
