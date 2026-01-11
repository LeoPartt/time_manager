import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_colors.dart';
import 'package:time_manager/core/constants/app_sizes.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: Colors.white,
      onSurface: AppColors.textPrimary,
      error: AppColors.error,
      shadow: AppColors.shadow,
    ),
    
    scaffoldBackgroundColor: AppColors.backgroundLight,
    
    // TextTheme amélioré
    textTheme: _buildTextTheme(isDark: false),
    
    // InputDecoration améliorée
    inputDecorationTheme: _buildInputTheme(isDark: false),
    
    // ElevatedButton amélioré
    elevatedButtonTheme: _buildButtonTheme(),
    
    // Card theme
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r16),
      ),
      color: Colors.white,
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.cardDark,
      onSurface: AppColors.textLight,
      error: AppColors.error,
      shadow: AppColors.shadowDark,
    ),
    
    scaffoldBackgroundColor: AppColors.backgroundDark,
    
    textTheme: _buildTextTheme(isDark: true),
    inputDecorationTheme: _buildInputTheme(isDark: true),
    elevatedButtonTheme: _buildButtonTheme(),
    
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r16),
      ),
      color: AppColors.cardDark,
    ),
  );

  static TextTheme _buildTextTheme({required bool isDark}) => TextTheme(
    displayLarge: TextStyle(
      color: isDark ? AppColors.textLight : AppColors.textPrimary,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.textDisplay,
      letterSpacing: -0.5,
    ),
    headlineMedium: TextStyle(
      color: isDark ? AppColors.textLight : AppColors.textPrimary,
      fontWeight: FontWeight.w600,
      fontSize: AppSizes.textXxl,
    ),
    bodyLarge: TextStyle(
      color: isDark ? AppColors.textLight : AppColors.textPrimary,
      fontSize: AppSizes.textLg,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      color: isDark ? AppColors.textSecondary : AppColors.textSecondary,
      fontSize: AppSizes.textMd,
      height: 1.4,
    ),
  );

  static InputDecorationTheme _buildInputTheme({required bool isDark}) =>
      InputDecorationTheme(
        filled: true,
        fillColor: isDark 
            ? AppColors.cardDark.withValues(alpha:0.5)
            : AppColors.backgroundLight,
        
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppSizes.p16,
          horizontal: AppSizes.p16,
        ),
        
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
          borderSide: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
          borderSide: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
          borderSide: const BorderSide(
            color: AppColors.error,
          ),
        ),
        
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
      );

  static ElevatedButtonThemeData _buildButtonTheme() =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: AppColors.primary.withValues(alpha:0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.r12),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: AppSizes.p16,
            horizontal: AppSizes.p24,
          ),
          textStyle: const TextStyle(
            fontSize: AppSizes.textLg,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      );
}