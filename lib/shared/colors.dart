import 'package:flutter/material.dart';

class AppColors {
  static const MaterialColor primaryColor = MaterialColor(_primaryColorValue, <int, Color>{
    50: Color(0xFFF9EFE6),
    100: Color(0xFFF1D8C1),
    200: Color(0xFFE8BE97),
    300: Color(0xFFDEA46D),
    400: Color(0xFFD7914E),
    500: Color(_primaryColorValue),
    600: Color(0xFFCB752A),
    700: Color(0xFFC46A23),
    800: Color(0xFFBE601D),
    900: Color(0xFFB34D12),
  });
  static const int _primaryColorValue = 0xFFD07D2F;

  static const MaterialColor secondaryColor = MaterialColor(_secondaryColorValue, <int, Color>{
    50: Color(0xFFE6F0F9),
    100: Color(0xFFC1DAF1),
    200: Color(0xFF97C1E8),
    300: Color(0xFF6DA8DE),
    400: Color(0xFF4E95D7),
    500: Color(_secondaryColorValue),
    600: Color(0xFF2A7ACB),
    700: Color(0xFF236FC4),
    800: Color(0xFF1D65BE),
    900: Color(0xFF1252B3),
  });
  static const int _secondaryColorValue = 0xFF2F82D0;
}