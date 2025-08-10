import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppConfig {
  static const String appName = 'Resource Guardian';
  static const String version = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'http://localhost:8080/api';
  static const Duration requestTimeout = Duration(seconds: 30);
  
  // App Settings
  static const bool enableLogging = true;
  static const bool enableAnalytics = false;
  
  // Theme Settings
  static const bool enableDarkMode = false;
  static const bool enableSystemTheme = true;
  
  // Security Settings
  static const int sessionTimeoutMinutes = 30;
  static const bool enableBiometric = true;
  
  // Initialize app configuration
  static Future<void> initialize() async {
    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    
    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
