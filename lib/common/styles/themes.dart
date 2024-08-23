import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tic_tac_toe/common/styles/colors.dart';

class Themes {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    splashColor: Colors.transparent,
    scaffoldBackgroundColor: MyColors.antiFlashWhite.withOpacity(0.9),
    textTheme: GoogleFonts.nunitoTextTheme(),
    primaryColor: MyColors.lavender,
    colorScheme: ColorScheme(brightness: Brightness.light, primary: Colors.black, onPrimary: MyColors.gray, secondary: Colors.white, onSecondary: MyColors.gray, error: Colors.red, onError: Colors.red, surface: Colors.transparent, onSurface: Colors.transparent)
  );


  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    splashColor: Colors.transparent,
    scaffoldBackgroundColor: MyColors.dark,
    textTheme: GoogleFonts.nunitoTextTheme(),
    primaryColor: MyColors.lavender,
    colorScheme: ColorScheme(brightness: Brightness.dark, primary: Colors.white, onPrimary: MyColors.gray, secondary: Colors.black, onSecondary: MyColors.gray, error: Colors.red, onError: Colors.red, surface: Colors.transparent, onSurface: Colors.transparent)
  );

}