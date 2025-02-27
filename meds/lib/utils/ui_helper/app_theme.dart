import 'package:flutter/material.dart';
import 'package:meds/utils/ui_helper/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    hintColor: AppColors.secondaryColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.textColor, fontSize: 24, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: AppColors.textColor, fontSize: 16),
    ),
    appBarTheme: const AppBarTheme(
      color: AppColors.primaryColor,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.secondaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}