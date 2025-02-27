import 'package:flutter/material.dart';

class AppFonts {
  static const String primaryFont = 'Nunito'; // Primary font for regular text
  static const String secondaryFont = 'Poppins'; // Secondary font for medium and semi-bold text

  static final TextStyle heading = TextStyle(
    fontFamily: secondaryFont,
    fontWeight: FontWeight.w600, // SemiBold equivalent for Poppins
    fontSize: 20,
    color: Colors.black, // Default heading color
  );

  static final TextStyle body = TextStyle(
    fontFamily: primaryFont,
    fontWeight: FontWeight.normal, // Regular weight for Nunito
    fontSize: 16,
    color: Colors.black87, // Slightly lighter text color for readability
  );

  static final TextStyle button = TextStyle(
    fontFamily: secondaryFont,
    fontWeight: FontWeight.w500, // Medium weight for Poppins
    fontSize: 16,
    color: Colors.white, // Default button text color
  );

  static const TextStyle headlineLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black, // Replace with desired color
  );
}
