import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

ThemeData lightTheme = ThemeData(

  fontFamily: 'DM Sans',

  appBarTheme:   const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontSize: 16,
      color: onBackgroundLight,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic
    ),
    actionsIconTheme: IconThemeData(
      color: onBackgroundLight,
    ),
  ),
  // primarySwatch: primaryLight,
  colorScheme:const ColorScheme.light(
    primary: primaryLight,
    secondary: secondaryLight
  ),
  shadowColor: surfaceLight,
  scaffoldBackgroundColor: backgroundLight,
  bottomNavigationBarTheme:  const BottomNavigationBarThemeData(
    backgroundColor: surfaceLight,
    elevation: 2,
    selectedItemColor: primaryLight,
    unselectedItemColor:onSurfaceLight,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
  ),
);

ThemeData darkTheme = ThemeData(
  appBarTheme:   AppBarTheme(
    backgroundColor: backgroundDark,
    elevation: 0,
    titleTextStyle: const TextStyle(
        fontSize: 16,
        color: onBackgroundDark,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.italic
    ),
    actionsIconTheme: const IconThemeData(
      color: onBackgroundDark,
    ),
  ),
  primarySwatch: secondaryDark,
  colorScheme:const ColorScheme.dark(),
  scaffoldBackgroundColor: backgroundDark,

  bottomNavigationBarTheme:  BottomNavigationBarThemeData(
    backgroundColor: surfaceDark,
    elevation: 20,
    selectedItemColor: primaryDark,
    unselectedItemColor:onSecondaryDark,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
  ),
);