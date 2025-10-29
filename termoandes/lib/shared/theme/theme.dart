import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.darkText50,
    primaryColor: AppColors.green500,
    fontFamily: 'NunitoSans',
    textTheme: TextTheme(
      bodySmall: TextStyle(color: AppColors.darkText200),
      bodyMedium: TextStyle(color: AppColors.darkText200),
      bodyLarge: TextStyle(color: AppColors.darkText200),
    ),
    iconTheme: IconThemeData(
      color: AppColors.darkText200,
      size: 24,
    ),
  );
}
