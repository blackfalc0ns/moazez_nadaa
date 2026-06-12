import 'package:flutter/material.dart';

/// Application border radius constants
/// Centralizes border radius values for consistent UI
class AppRadius {
  AppRadius._();

  // Base radius values
  static const double radius0 = 0;
  static const double radius1 = 4;
  static const double radius2 = 8;
  static const double radius3 = 12;
  static const double radius4 = 16;
  static const double radius5 = 20;
  static const double radius6 = 24;
  static const double radius7 = 32;
  static const double radius8 = 40;
  static const double radiusCircular = 100;

  // Preset radius values
  static const double radiusXS = 4;
  static const double radiusS = 8;
  static const double radiusM = 12;
  static const double radiusL = 16;
  static const double radiusXL = 24;
  static const double radiusXXL = 32;
  static const double radiusFull = 100;

  // Border radius presets for common widgets
  static const BorderRadius buttonRadius = BorderRadius.all(Radius.circular(radiusM));
  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(radiusL));
  static const BorderRadius inputRadius = BorderRadius.all(Radius.circular(radiusM));
  static const BorderRadius bottomSheetRadius = BorderRadius.only(
    topLeft: Radius.circular(radiusXL),
    topRight: Radius.circular(radiusXL),
  );
  static const BorderRadius dialogRadius = BorderRadius.all(Radius.circular(radiusL));
  static const BorderRadius chipRadius = BorderRadius.all(Radius.circular(radiusCircular));
  static const BorderRadius avatarRadius = BorderRadius.all(Radius.circular(radiusCircular));
  static const BorderRadius imageRadius = BorderRadius.all(Radius.circular(radiusM));

  // Helper methods
  static BorderRadius all(double radius) {
    return BorderRadius.all(Radius.circular(radius));
  }

  static BorderRadius only({
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
  }) {
    return BorderRadius.only(
      topLeft: Radius.circular(topLeft),
      topRight: Radius.circular(topRight),
      bottomLeft: Radius.circular(bottomLeft),
      bottomRight: Radius.circular(bottomRight),
    );
  }

  static BorderRadius horizontal(double radius) {
    return BorderRadius.horizontal(left: Radius.circular(radius), right: Radius.circular(radius));
  }

  static BorderRadius vertical(double radius) {
    return BorderRadius.vertical(top: Radius.circular(radius), bottom: Radius.circular(radius));
  }

  // Circular border radius helper
  static BorderRadius circular(double percent) {
    return BorderRadius.circular(radiusCircular * percent / 100);
  }
}