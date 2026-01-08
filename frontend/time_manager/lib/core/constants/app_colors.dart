import 'package:flutter/material.dart';

/// Central color palette for the Time Manager application.
/// This file defines all the color constants used across the app.

class AppColors {
  // ───────────────────────────────
  //  Brand Colors (Primary Identity)
  // ───────────────────────────────
  static const Color primary = Color(0xFF4A90E2);      // Bleu professionnel
  static const Color secondary = Color(0xFF485563);    // Bleu nuit (fond général)
  static const Color accent = Color(0xFFA8B3C2);       // Gris bleuté clair

  // ───────────────────────────────
  //  Backgrounds & Surfaces
  // ───────────────────────────────
  static const Color backgroundLight = Color(0xFFF2F4F7);
  static const Color backgroundDark = Color(0xFF1E1E1E);
  static const Color cardLight = Color(0xFFA8B3C2);
  static const Color cardDark = Color(0xFFA8B3C2);

  // ───────────────────────────────
  //  Text Colors
  // ───────────────────────────────
  static const Color textPrimary = Color(0xFF1C1C1C);  // Texte principal sombre
  static const Color textSecondary = Color(0xFF444444);
  static const Color textLight = Color(0xFFFFFFFF);

  // ───────────────────────────────
  // Status & Feedback
  // ───────────────────────────────
  static const Color success = Color(0xFF5CB85C);
  static const Color warning = Color(0xFFF0AD4E);
  static const Color error = Color(0xFFD9534F);
  static const Color info = Color(0xFF5BC0DE);

  // ───────────────────────────────
  //  Shadows & Borders
  // ───────────────────────────────
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF2E2E2E);
  static const Color shadow = Color(0x29000000); // 16% opacity black
 static const Color shadowDark =  Color(0x29FFFFFF); // white, 16% opacity

  // ───────────────────────────────
  //  Gradients
  // ───────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF485563), Color(0xFF29323C)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ───────────────────────────────
  // Theme toggles
  // ───────────────────────────────
  static const Color lightIcon = Color(0xFF4A90E2);
  static const Color darkIcon = Color(0xFFA8B3C2);
}
