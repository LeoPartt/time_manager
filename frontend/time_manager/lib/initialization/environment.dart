import 'dart:developer' as dev;

/// Environment configuration manager.
class Environment {
  static String current = const String.fromEnvironment('env', defaultValue: 'dev');
  static String get baseUrl {
    switch (current) {
      case 'prod':
        return 'https://timemanager.duckdns.org';
      case 'staging':
        return 'https://staging.time-manager.com';
      default:
        return 'http://localhost:8080';
    }
  }

  static Future<void> load() async {
    dev.log('🌱 Environment loaded: $current');
  }
}
