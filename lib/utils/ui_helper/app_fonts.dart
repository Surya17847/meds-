import 'package:flutter/material.dart';
import 'package:meds/utils/ui_helper/app_colors.dart'; // Import color scheme

class AppFonts {
  static const String primaryFont = 'Poppins'; // Primary font for regular text
  static const String secondaryFont = 'Poppins'; // Secondary font for medium and semi-bold text

  static final TextStyle heading = TextStyle(
    fontFamily: secondaryFont,
    fontWeight: FontWeight.w600, // SemiBold for emphasis
    fontSize: 22,
    color: AppColors.primary, // Use the primary blue-purple color for headings
  );

  static final TextStyle body = TextStyle(
    fontFamily: primaryFont,
    fontWeight: FontWeight.normal,
    fontSize: 16,
    color: AppColors.textColor, // Dark grey for readability
  );

  static final TextStyle button = TextStyle(
    fontFamily: secondaryFont,
    fontWeight: FontWeight.w500, // Medium weight for buttons
    fontSize: 16,
    color: AppColors.buttonTextColor, // White or contrasting color for clarity
  );

  static final TextStyle caption = TextStyle(
    fontFamily: primaryFont,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColors.textColorSecondary, // Light grey for subtitles
  );

  static const TextStyle headlineLarge = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: AppColors.primary, // Strong contrast for headlines
  );
}
