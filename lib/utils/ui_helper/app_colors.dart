import 'package:flutter/material.dart';

class AppColors {
  // Primary and Secondary Colors (Updated)
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

  // Primary Accent
  static const Color primary = Color.fromARGB(255, 255, 255, 255); // Ensuring consistency in theming

  // Button Colors (Updated)
  static const Color buttonPrimaryColor = primaryColor; // Matches primary blue
  static const Color buttonSecondaryColor = secondaryColor; // Matches soft purple
  static const Color buttonTextColor = Colors.white; // Ensuring readability on buttons
  static const Color buttonDisabledColor = Color(0xFFC8C8C8); // Neutral grey for disabled states

  // Status Colors (Kept the same)
  static const Color errorColor = Color(0xFFC8382F); // Red for error messages
  static const Color successColor = Color(0xFF2EC832); // Green for success
  static const Color warningColor = Color(0xFFC8C832);

  static var shadowColor; // Yellow for warnings
}
