import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColor = Color(0xFF854F6C);
const secondaryColor = Color(0xFFFBE4D8);
const surfaceColor = Color(0xFFDFB6B2);
const onBackgroundColor = Color(0xFF522B5B);
const onPrimaryColor = Color(0xFFFFF9F6);

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
      fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1.25),
  bodySmall: GoogleFonts.nunitoSans(
      fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.4),
  labelSmall: GoogleFonts.nunitoSans(
      fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);