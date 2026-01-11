
import 'package:flutter/material.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;

  // Helpers statiques
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileBreakpoint &&
      MediaQuery.of(context).size.width < tabletBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint;

  // Helper pour obtenir le type
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= tabletBreakpoint) return DeviceType.desktop;
    if (width >= mobileBreakpoint) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  // Helper pour colonnes adaptatives
  static int getCrossAxisCount(BuildContext context, {
    int mobile = 1,
    int tablet = 2,
    int desktop = 3,
  }) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet;
    return mobile;
  }

  // Helper pour padding adaptatif
  static double getResponsivePadding(BuildContext context, {
    double mobile = 16.0,
    double tablet = 24.0,
    double desktop = 32.0,
  }) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet;
    return mobile;
  }

  @override
  Widget build(BuildContext context) {
    if (isDesktop(context) && desktop != null) return desktop!;
    if (isTablet(context) && tablet != null) return tablet!;
    return mobile;
  }
}

enum DeviceType { mobile, tablet, desktop }

// ✅ Extension pour faciliter l'usage
extension ResponsiveExtension on BuildContext {
  bool get isMobile => ResponsiveBuilder.isMobile(this);
  bool get isTablet => ResponsiveBuilder.isTablet(this);
  bool get isDesktop => ResponsiveBuilder.isDesktop(this);
  DeviceType get deviceType => ResponsiveBuilder.getDeviceType(this);
}