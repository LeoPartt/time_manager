import 'dart:ui' as ui;

String getDefaultCountryCode() {
final locale = ui.PlatformDispatcher.instance.locale.countryCode ?? 'FR';
  return locale; 
}
