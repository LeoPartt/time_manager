import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_sizes.dart';

/*Utility class that helps ensure accessibility consistency across the app.

 It adapts color contrast, text scaling, and semantics to improve
 usability for all users (especially with visual impairments).*/
class AccessibilityUtils {
  /* Ensures sufficient color contrast based on the current theme brightness.
   If the background color is too dark or too bright, this method
   returns a text color that ensures readable contrast*/
  static Color ensureContrast(BuildContext context, Color background) {
    final luminance = background.computeLuminance();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Return contrasting color depending on mode and luminance
    if (luminance < 0.5) {
      return Colors.white; // background too dark → white text
    } else {
      return isDarkMode ? Colors.grey[200]! : Colors.black; // background clear
    }
  }

  /* Wraps a widget with semantic information for screen readers.
   This helps assistive technologies describe widgets verbally.*/
  static Widget withLabel({
    required String label,
    required Widget child,
    bool hidden = false,
  }) {
    return Semantics(
      label: label,
      excludeSemantics: hidden,
      child: child,
    );
  }

   /// Adds a semantic tooltip (for icons, buttons, etc.).
  ///
  /// Uses both [Tooltip] and [Semantics] for better support.
  static Widget withTooltip(BuildContext context,{
    required String tooltip,
    required Widget child,
    Duration waitDuration = const Duration(milliseconds: 400),
  }) {
    final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

    return Tooltip(
      message: tooltip,
      waitDuration: waitDuration,
      decoration: BoxDecoration(
        color: colorScheme.onSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle:  TextStyle(color: colorScheme.surface),
      child: Semantics(
        label: tooltip,
        hint: tooltip,
        button: true,
        child: child,
      ),
    );
  }

  /// Scales a text size according to user accessibility settings.
  ///
  /// Respects the device's textScaleFactor and stays within safe bounds.
  static double accessibleText(BuildContext context, double baseSize) {
    final scale = MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.4);

    return baseSize * scale;
  }

  /// Returns true if the system text scale is large (e.g., accessibility zoom)
  static bool isTextZoomed(BuildContext context) {
final scale = MediaQuery.of(context).textScaler.scale(1.0);
    return scale > 1.2;
  }

  /// Creates an accessible button with tooltip and semantic label.
  ///
  /// Useful for icon buttons that don’t have visible text.
  static Widget accessibleIconButton(BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? color,
  }) {
    final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

    return withTooltip(
      context,
      tooltip: label,
      child: IconButton(
        icon: Icon(icon, color: color ?? colorScheme.primary),
        onPressed: onPressed,
        tooltip: label,
      ),
    );
  }

  /// Creates an accessible, theme-aware text.
 
  static Widget accessibleTextWidget(
    BuildContext context,
    String text, {
    double baseSize = AppSizes.textMd,
    FontWeight weight = FontWeight.w500,
    Color? color,
  }) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? AccessibilityUtils.ensureContrast(context, theme.colorScheme.surface);

    return Semantics(
      label: text,
      child: Text(
        text,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: effectiveColor,
          fontSize: accessibleText(context, baseSize),
          fontWeight: weight,
        ),
      ),
    );
  }
}
