import 'package:flutter/material.dart';
import 'app_colors.dart';

class TvTheme {
  TvTheme._();

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bgDark,
        colorScheme: ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.accentGold,
          surface: AppColors.bgSurface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.bgDark,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: AppColors.bgCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 48,
          ),
          headlineMedium: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 36,
          ),
          titleLarge: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 28,
          ),
          titleMedium: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 24,
          ),
          bodyLarge: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
          ),
          bodyMedium: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 20,
          ),
          bodySmall: TextStyle(
            color: AppColors.textMuted,
            fontSize: 18,
          ),
        ),
      );
}
