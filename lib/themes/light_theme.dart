// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

ThemeData customLightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
      // backgroundColor: Color(0xff6ee7b7),
      ),
  colorScheme: ColorScheme.light(
    background: Colors.white,
    primary: const Color(0xfffecaca),
    secondary: const Color(0xffd1fae5),
    tertiary: const Color(0xff6ee7b7),
    onTertiary: const Color(0xff059669),
  ),

  // text theme
  textTheme: TextTheme(
    labelMedium: TextStyle(
      color: Colors.black,
    ),
  ),

  // elevated button theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(const Color(0xffd1fae5)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  ),

  // text button theme
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor:
          MaterialStateProperty.all<Color>(const Color(0xff000000)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  ),
);
