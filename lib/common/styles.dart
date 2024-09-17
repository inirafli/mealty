import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const lightPrimaryColor = Color(0xFF854F6C);
const lightSecondaryColor = Color(0xFFFBE4D8);
const lightSurfaceColor = Color(0xFFDFB6B2);
const lightOnBackgroundColor = Color(0xFF522B5B);
const lightOnPrimaryColor = Color(0xFFFFF9F6);

final TextTheme appTextTheme = TextTheme(
  displayLarge: GoogleFonts.nunitoSans(
      fontSize: 96, fontWeight: FontWeight.w300, letterSpacing: -1.5),
  displayMedium: GoogleFonts.nunitoSans(
      fontSize: 60, fontWeight: FontWeight.w600, letterSpacing: -0.5),
  displaySmall: GoogleFonts.nunitoSans(fontSize: 48, fontWeight: FontWeight.w600),
  headlineMedium: GoogleFonts.nunitoSans(
      fontSize: 32, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  headlineSmall: GoogleFonts.nunitoSans(fontSize: 24, fontWeight: FontWeight.w700),
  titleLarge: GoogleFonts.nunitoSans(
      fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  titleMedium: GoogleFonts.nunitoSans(
      fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
  titleSmall: GoogleFonts.nunitoSans(
      fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  bodyLarge: GoogleFonts.nunitoSans(
      fontSize: 18, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyMedium: GoogleFonts.nunitoSans(
      fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  labelLarge: GoogleFonts.nunitoSans(
      fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.4),
  bodySmall: GoogleFonts.nunitoSans(
      fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.4),
  labelSmall: GoogleFonts.nunitoSans(
      fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
);

final ThemeData lightTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: lightPrimaryColor,
    secondary: lightSecondaryColor,
    surface: lightSurfaceColor,
    onBackground: lightOnBackgroundColor,
    onPrimary: lightOnPrimaryColor,
  ),
  appBarTheme: const AppBarTheme(
    scrolledUnderElevation: 0.8,
    backgroundColor: lightPrimaryColor,
    foregroundColor: lightOnPrimaryColor,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: lightPrimaryColor,
      foregroundColor: lightOnPrimaryColor,
      disabledBackgroundColor: lightPrimaryColor,
      disabledForegroundColor: lightOnPrimaryColor,
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    ),
  ),
  textTheme: appTextTheme,
);