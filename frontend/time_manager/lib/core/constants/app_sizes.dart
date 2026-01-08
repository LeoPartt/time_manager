import 'package:flutter/material.dart';

/// Global responsive sizing system for Time Manager.
///
/// Centralizes all paddings, radius, icon, text and layout sizes.
class AppSizes {
  // ───────────────────────────────
  //  Padding & Margins
  // ───────────────────────────────
  static const double p2 = 2.0;
  static const double p4 = 4.0;
  static const double p6 = 6.0;
  static const double p8 = 8.0;
  static const double p12 = 12.0;
  static const double p16 = 16.0;
  static const double p20 = 20.0;
  static const double p24 = 24.0;
  static const double p32 = 32.0;

  // ───────────────────────────────
  //  Border Radius
  // ───────────────────────────────
  static const double r4 = 4.0;
  static const double r8 = 8.0;
  static const double r12 = 12.0;
  static const double r16 = 16.0;
  static const double r24 = 24.0;
  static const double r32 = 32.0;

  // ───────────────────────────────
  //  Icon sizes
  // ───────────────────────────────
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXl = 48.0;

  /// Responsive icon sizing
  static double responsiveIcon(BuildContext context, double size) {
    final width = MediaQuery.of(context).size.width;
    if (width < 350) return size * 0.85;
    if (width > 600) return size * 1.2;
    return size;
  }

  // ───────────────────────────────
  //  Text sizes (base, scalable)
  // ───────────────────────────────
  static const double textXs = 10.0;
  static const double textSm = 12.0;
  static const double textMd = 14.0;
  static const double textLg = 16.0;
  static const double textXl = 20.0;
  static const double textXxl = 24.0;
  static const double textDisplay = 32.0;

  // ───────────────────────────────
  //  Container sizes 
  // ───────────────────────────────
  static double appContainerWidth(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.7 ;
  }  
  static double appContainerHeight(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.08 ;
  }
  static double appSmallContainerWidth(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.35 ;
  }  
  static double appSmallContainerHeight(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.08 ;
  }

  static double dashboardHeight(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.06 ;
  }

  static double dashboardWidth(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.9 ;
  }

  // ───────────────────────────────
  //  Layout helpers (width/height)
  // ───────────────────────────────
  static double responsiveWidth(BuildContext context, double size) {
    final width = MediaQuery.of(context).size.width;
    if (width < 350) return size * 0.85; // Small phones
    if (width > 600) return size * 1.15; // Tablets
    return size;
  }

  static double responsiveHeight(BuildContext context, double size) {
    final height = MediaQuery.of(context).size.height;
    if (height < 650) return size * 0.9;
    if (height > 900) return size * 1.1;
    return size;
  }

  // ───────────────────────────────
  // 🔹 Special containers (cards, forms)
  // ───────────────────────────────
  static double cardWidth(BuildContext context) =>
      responsiveWidth(context, 600);

  static double cardHeight(BuildContext context) =>
      responsiveHeight(context, 300);

  static double buttonHeight(BuildContext context) =>
      responsiveHeight(context, 48);
  /// Returns a responsive text size using MediaQuery scaling.
  static double responsiveText(BuildContext context, double size) {
final scale = MediaQuery.of(context).textScaler.scale(1.0);
    return size * scale.clamp(0.9, 1.2);
  }
}
