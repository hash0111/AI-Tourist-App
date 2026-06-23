import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const deepIndigo = Color(0xFF1A1035);
  static const saffron = Color(0xFFFF6B00);
  static const saffronOrange = Color(0xFFFF8F00);
  static const forestGreen = Color(0xFF2E7D32);
  static const goldAccent = Color(0xFFFFD700);
  static const turmericGold = Color(0xFFF5A623);
  static const ivory = Color(0xFFFAF3E0);
  static const warmIvory = Color(0xFFF8F5EE);
  static const mutedJade = Color(0xFF2D7A5F);

  static const surfaceBg = Color(0xFFF5F3F0);
  static const cardBg = Colors.white;
  static const textPrimary = Color(0xFF1A1035);
  static const textSecondary = Color(0xFF6B6580);
  static const textOnDark = Colors.white;
  static const divider = Color(0xFFEEEAE3);
  static const shimmer = Color(0xFFE8E4DD);

  static const saffronLight = Color(0xFFFFF0E0);
  static const jadeLight = Color(0xFFE8F5EF);
  static const goldLight = Color(0xFFFFF8EB);
  static const indigoLight = Color(0xFFEDEAF5);

  static const gradientHero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [deepIndigo, Color(0xFF2D1B69), Color(0xFF3D2B7F)],
  );

  static const gradientPlanner = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [mutedJade, Color(0xFF3A9B7A)],
  );

  static const gradientSaffron = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [saffron, Color(0xFFFF8C33)],
  );

  static const gradientGold = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [turmericGold, Color(0xFFFFC107)],
  );

  static const gradientMythology = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [deepIndigo, Color(0xFF2D1B69), Color(0xFF1A1035)],
  );

  static Map<String, Color> categoryColors = {
    'Waterfalls': const Color(0xFF2D7A5F),
    'Wildlife': const Color(0xFF1A1035),
    'Temples': const Color(0xFFFF6B00),
    'Heritage': const Color(0xFFF5A623),
    'Festivals': const Color(0xFFFF6B00),
    'Food': const Color(0xFFF5A623),
    'Adventure': const Color(0xFF2D7A5F),
    'Spiritual': const Color(0xFF1A1035),
  };
}
