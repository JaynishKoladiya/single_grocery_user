// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:singlegrocery/common%20class/color.dart';

class MyThemes {
  static final DarkTheme = ThemeData(
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith(
          (states) => Colors.transparent,
        ),
      ),
    ),
    primaryColor: Color(0xff0D9444),
    iconTheme: IconThemeData(color: Colors.white),
    appBarTheme: AppBarTheme(
      actionsIconTheme: IconThemeData(
        color: Colors.white,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      titleTextStyle: TextStyle(
        color: Colors.white,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.black,
    ),

    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      surface: Colors.transparent,
      onSurface: Colors.black,
      primary: Colors.white,
      onPrimary: Colors.grey,
      secondary: Colors.grey,
      onSecondary: Colors.grey,
      background: Colors.transparent,
      onBackground: Colors.grey,
      error: Colors.grey,
      onError: Colors.grey,
    ),
    // primaryColor: color.primarycolor,
    primaryIconTheme: IconThemeData(color: Colors.white),
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.dark,
  );

  static final LightTheme = ThemeData(
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith(
          (states) => Colors.transparent,
        ),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.white),
    // primarySwatch: Colors.red,
    primaryColor:color.primarycolor,
    primaryColorDark: color.black,
    appBarTheme: const AppBarTheme(
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark, // 2
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(color: Colors.black)),
    // primaryColor: Colors.blue,

    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black12,
    ),
    scaffoldBackgroundColor: Colors.white,
    // primarySwatch: Colors.grey,
    colorScheme: const ColorScheme.light(),
  );
}
