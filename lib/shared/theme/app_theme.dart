import 'package:flutter/material.dart';
import 'lumen_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kAmber,
          brightness: Brightness.dark,
        ).copyWith(
          surface: kBg,
          onSurface: kText,
          primary: kAmber,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: kBg,
        appBarTheme: const AppBarTheme(
          backgroundColor: kBg,
          foregroundColor: kText,
          elevation: 0,
        ),
        sliderTheme: const SliderThemeData(
          activeTrackColor: kAmber,
          thumbColor: kAmber,
          inactiveTrackColor: kHair,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: kSheet,
          contentTextStyle: TextStyle(color: kText, fontSize: 12),
        ),
      );
}
