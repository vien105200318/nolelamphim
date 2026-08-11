import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static const String fontFamily = 'BeVietnamPro';

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bgDark,
        fontFamily: fontFamily,
        colorScheme: ColorScheme.dark(
          primary: AppColors.gradientStart,
          secondary: AppColors.gradientMid,
          tertiary: AppColors.gradientEnd,
          surface: AppColors.bgSurface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            fontFamily: fontFamily,
          ),
          iconTheme: IconThemeData(color: AppColors.textPrimary),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          selectedItemColor: AppColors.textPrimary,
          unselectedItemColor: AppColors.textMuted,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.transparent,
          indicatorColor: AppColors.gradientMid.withValues(alpha: 0.16),
          labelTextStyle: WidgetStatePropertyAll(
            const TextStyle(
              fontFamily: fontFamily,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: AppColors.textPrimary);
            }
            return const IconThemeData(color: AppColors.textMuted);
          }),
        ),
        cardTheme: CardThemeData(
          color: AppColors.glassWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontFamily: fontFamily,
          ),
          headlineLarge: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontFamily: fontFamily,
          ),
          headlineMedium: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontFamily: fontFamily,
          ),
          titleLarge: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontFamily: fontFamily,
          ),
          titleMedium: TextStyle(
            color: AppColors.textSecondary,
            fontFamily: fontFamily,
          ),
          bodyLarge: TextStyle(
            color: AppColors.textPrimary,
            fontFamily: fontFamily,
          ),
          bodyMedium: TextStyle(
            color: AppColors.textSecondary,
            fontFamily: fontFamily,
          ),
          bodySmall: TextStyle(
            color: AppColors.textMuted,
            fontFamily: fontFamily,
          ),
        ),
      );
}
