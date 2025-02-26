import 'package:flutter/material.dart';

class AppColors {
  // Primary and Secondary Colors
  static const Color primaryColor = Color(0xFFFF4D4D); // Red for primary buttons, highlights, or notifications
  static const Color secondaryColor = Color(0xFFFFB3B3); // Soft Pink for secondary buttons or accents
  
  // Text Colors
  static const Color textColorSecondary = Color(0xFF757575); // Light grey for secondary text
  static const Color textColor = Color(0xFF333333); // Dark grey for primary text
  static const Color iconColor = Color(0xFF333333); // Same as primary text for consistency
  
  // Background Colors
  static const Color backgroundColor = Color(0xFFF0F0F0); // Light Gray for secondary backgrounds or borders
  static const Color whiteColor = Colors.white; // White for contrast on dark elements
  static const Color lightGrey = Color(0xFFF0F0F0); // Same as background color for consistency in secondary elements

  // Button Colors
  static const Color buttonPrimaryColor = primaryColor; // Matches red for primary button
  static const Color buttonSecondaryColor = Color.fromARGB(255, 255, 138, 138); // Matches soft pink for secondary button
  static const Color buttonTextColor = Colors.white; // Ensuring readability on buttons
  static const Color buttonDisabledColor = Color(0xFFC8C8C8); // Neutral grey for disabled states

  // Status Colors
  static const Color errorColor = Colors.red; // Red for error messages (can keep this as is for error)
  static const Color successColor = Colors.greenAccent; // Green for success
  static const Color warningColor = Colors.yellowAccent; // Yellow for warnings
}

class AppFonts {
  static const String primaryFont = 'Poppins'; // Primary font for regular text
  static const String secondaryFont = 'Poppins'; // Secondary font for medium and semi-bold text

  static final TextStyle heading = TextStyle(
    fontFamily: secondaryFont,
    fontWeight: FontWeight.w600, // SemiBold for emphasis
    fontSize: 24,
    color: AppColors.whiteColor, // Use red for headings to match primary theme
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
    color: AppColors.buttonTextColor, // White for contrast on buttons
  );

  static final TextStyle caption = TextStyle(
    fontFamily: primaryFont,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColors.textColorSecondary, // Light grey for subtitles
  );

  static const TextStyle headline = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.whiteColor, // Strong white color for headlines
  );
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    hintColor: AppColors.secondaryColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,

    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontFamily: AppFonts.secondaryFont, // Set custom font for heading
        color: AppColors.textColor,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        fontFamily: AppFonts.primaryFont, // Set custom font for body text
        color: AppColors.textColor,
        fontSize: 16,
      ),
    ),
    
    appBarTheme: const AppBarTheme(
      color: AppColors.primaryColor,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white, 
        fontSize: 20, 
        fontWeight: FontWeight.bold,
      ),
    ),

    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.buttonPrimaryColor, // Updated to match the new red color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonPrimaryColor, // Red for primary button
        foregroundColor: AppColors.whiteColor, // White text
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryColor, // Red outline
        side: const BorderSide(color: AppColors.primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.secondaryColor), // Soft pink for focus state
      ),
      hintStyle: TextStyle(color: AppColors.textColorSecondary),
    ),

    iconTheme: const IconThemeData(
      color: AppColors.iconColor, // Dark color for consistency
    ),

    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
