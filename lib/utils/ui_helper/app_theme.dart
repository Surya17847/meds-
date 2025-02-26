import 'package:flutter/material.dart';

class AppColors {
  // Primary and Secondary Colors
  static const Color primaryColor = Color.fromARGB(255, 20, 56, 96); // Vibrant Blue
  static const Color secondaryColor = Color.fromARGB(255, 55, 43, 118); // Soft Purple
  
  // Text Colors
  static const Color textColorSecondary = Color(0xFF757575); // Light grey for secondary text
  static const Color textColor = Color.fromARGB(168, 45, 45, 45); // Dark grey for primary text
  static const Color iconColor = Color(0xFF2D2D2D); // Same as primary text for consistency
  
  // Background Colors
  static const Color backgroundColor = Color(0xFFF5F7FA); // Light cool grey for a modern feel
  static const Color whiteColor = Colors.white; // White for contrast on dark elements
  static const Color lightGrey = Color(0xFFD3D3D3); // Subtle grey for dividers or inactive elements

  // Button Colors
  static const Color buttonPrimaryColor = primaryColor; // Matches primary blue
  static const Color buttonSecondaryColor = secondaryColor; // Matches soft purple
  static const Color buttonTextColor = Colors.white; // Ensuring readability on buttons
  static const Color buttonDisabledColor = Color(0xFFC8C8C8); // Neutral grey for disabled states

  // Status Colors
  static const Color errorColor = Color(0xFFC8382F); // Red for error messages
  static const Color successColor = Color(0xFF2EC832); // Green for success
  static const Color warningColor = Color(0xFFC8C832);
}

class AppFonts {
  static const String primaryFont = 'Poppins'; // Primary font for regular text
  static const String secondaryFont = 'Poppins'; // Secondary font for medium and semi-bold text

  static final TextStyle heading = TextStyle(
    fontFamily: secondaryFont,
    fontWeight: FontWeight.w600, // SemiBold for emphasis
    fontSize: 22,
    color: AppColors.primaryColor, // Use the primary blue-purple color for headings
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
    color: AppColors.primaryColor, // Strong contrast for headlines
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
      // button: AppFonts.button, // Use custom button style
      // caption: AppFonts.caption, // Use custom caption style
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
      buttonColor: AppColors.buttonPrimaryColor, // Updated to match the new theme
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonPrimaryColor, // Blue for primary button
        foregroundColor: AppColors.whiteColor, // White text
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryColor, // Blue outline
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
        borderSide: BorderSide(color: AppColors.secondaryColor),
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
