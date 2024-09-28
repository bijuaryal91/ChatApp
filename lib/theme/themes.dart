import 'package:flutter/material.dart';
import 'package:samparka/consts/colors.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    surface: AppColors.lightBackground,
    onSurface: AppColors.darkText,
    primary: AppColors.lightPrimary,
    secondary: AppColors.lightSecondary,
    tertiary: AppColors.lightInputField,
    error: AppColors.error,
    onError: AppColors.lightText,
  ),
  scaffoldBackgroundColor: AppColors.lightBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.lightPrimary,
    iconTheme: IconThemeData(color: AppColors.lightText),
    titleTextStyle: TextStyle(color: AppColors.lightText),
  ),
);

ThemeData darkmode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    surface: AppColors.darkBackground,
    onSurface: AppColors.lightText,
    primary: AppColors.darkPrimary,
    secondary: AppColors.darkSecondary,
    tertiary: AppColors.darkInputField,
    error: AppColors.error,
    onError: AppColors.lightText,
  ),
  scaffoldBackgroundColor:
      AppColors.darkBackground, // Scaffold background color
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.darkPrimary, // AppBar background color
    iconTheme: IconThemeData(color: AppColors.darkText), // AppBar icon color
    titleTextStyle: TextStyle(color: AppColors.darkText), // AppBar title color
  ),
);
