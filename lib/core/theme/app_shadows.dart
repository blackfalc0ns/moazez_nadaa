import 'package:flutter/material.dart';

/// Centralized shadow system for consistent elevations
/// Provides standardized shadow styles across the app
class AppShadows {
  AppShadows._();

  // ==================== SHADOW DEFINITIONS ====================

  /// No shadow
  static const List<BoxShadow> none = [];

  /// Extra small shadow - Subtle elevation (1dp)
  /// Use for: Slight separation, hover states
  static final List<BoxShadow> xs = [
    BoxShadow(
      color: Colors.black.withValues(alpha:0.04),
      blurRadius: 2,
      offset: const Offset(0, 1),
      spreadRadius: 0,
    ),
  ];

  /// Small shadow - Low elevation (2dp)
  /// Use for: Cards, chips, small buttons
  static final List<BoxShadow> sm = [
    BoxShadow(
      color: Colors.black.withValues(alpha:0.06),
      blurRadius: 4,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  /// Medium shadow - Standard elevation (4dp)
  /// Use for: Raised buttons, floating elements
  static final List<BoxShadow> md = [
    BoxShadow(
      color: Colors.black.withValues(alpha:  .08),
      blurRadius: 8,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  /// Large shadow - High elevation (8dp)
  /// Use for: Dialogs, bottom sheets, FAB
  static final List<BoxShadow> lg = [
    BoxShadow(
      color: Colors.black.withValues(alpha:0.10),
      blurRadius: 16,
      offset: const Offset(0, 8),
      spreadRadius: 0,
    ),
  ];

  /// Extra large shadow - Very high elevation (16dp)
  /// Use for: Modals, popovers, tooltips
  static final List<BoxShadow> xl = [
    BoxShadow(
      color: const Color.fromARGB(255, 110, 86, 86).withValues(alpha:0.12),
      blurRadius: 24,
      offset: const Offset(0, 12),
      spreadRadius: 0,
    ),
  ];

  /// Extra extra large shadow - Maximum elevation (24dp)
  /// Use for: Drawers, navigation bars
  static final List<BoxShadow> xxl = [
    BoxShadow(
      color: Colors.black.withValues(alpha:0.15),
      blurRadius: 32,
      offset: const Offset(0, 16),
      spreadRadius: 0,
    ),
  ];

  // ==================== SPECIALIZED SHADOWS ====================

  /// Card shadow - Optimized for cards
  static final List<BoxShadow> card = [
    BoxShadow(
      color: Colors.black.withValues(alpha:0.06),
      blurRadius: 8,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha:0.04),
      blurRadius: 4,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  /// Button shadow - Optimized for buttons
  static final List<BoxShadow> button = [
    BoxShadow(
      color: Colors.black.withValues(alpha:0.08),
      blurRadius: 6,
      offset: const Offset(0, 3),
      spreadRadius: 0,
    ),
  ];

  /// Floating shadow - For floating action buttons
  static final List<BoxShadow> floating = [
    BoxShadow(
      color: Colors.black.withValues(alpha:0.12),
      blurRadius: 16,
      offset: const Offset(0, 6),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha:0.08),
      blurRadius: 8,
      offset: const Offset(0, 3),
      spreadRadius: 0,
    ),
  ];

  /// Bottom sheet shadow - For bottom sheets
  static final List<BoxShadow> bottomSheet = [
    BoxShadow(
      color: Colors.black.withValues(alpha:0.15),
      blurRadius: 24,
      offset: const Offset(0, -4),
      spreadRadius: 0,
    ),
  ];

  /// Dialog shadow - For dialogs and modals
  static final List<BoxShadow> dialog = [
    BoxShadow(
      color: Colors.black.withValues(alpha:0.20),
      blurRadius: 32,
      offset: const Offset(0, 16),
      spreadRadius: 0,
    ),
  ];

  /// Dropdown shadow - For dropdown menus
  static final List<BoxShadow> dropdown = [
    BoxShadow(
      color: Colors.black.withValues(alpha:0.10),
      blurRadius: 12,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  /// Tooltip shadow - For tooltips
  static final List<BoxShadow> tooltip = [
    BoxShadow(
      color: Colors.black.withValues(alpha:0.12),
      blurRadius: 8,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  /// App bar shadow - For app bars
  static final List<BoxShadow> appBar = [
    BoxShadow(
      color: Colors.black.withValues(alpha:0.05),
      blurRadius: 4,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  /// Bottom nav shadow - For bottom navigation bars
  static final List<BoxShadow> bottomNav = [
    BoxShadow(
      color: Colors.black.withValues(alpha:0.08),
      blurRadius: 8,
      offset: const Offset(0, -2),
      spreadRadius: 0,
    ),
  ];

  // ==================== COLORED SHADOWS ====================

  /// Primary colored shadow
  static List<BoxShadow> primary({double opacity = 0.3}) => [
        BoxShadow(
          color: const Color(0xFF13B3B0).withValues(alpha:opacity),
          blurRadius: 12,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
      ];

  /// Success colored shadow
  static List<BoxShadow> success({double opacity = 0.3}) => [
        BoxShadow(
          color: const Color(0xFF10B981).withValues(alpha:opacity),
          blurRadius: 12,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
      ];

  /// Error colored shadow
  static List<BoxShadow> error({double opacity = 0.3}) => [
        BoxShadow(
          color: const Color(0xFFEF4444).withValues(alpha:opacity),
          blurRadius: 12,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
      ];

  /// Warning colored shadow
  static List<BoxShadow> warning({double opacity = 0.3}) => [
        BoxShadow(
          color: const Color(0xFFF59E0B).withValues(alpha:opacity),
          blurRadius: 12,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
      ];

  // ==================== HELPER METHODS ====================

  /// Create custom shadow
  static List<BoxShadow> custom({
    required Color color,
    required double blurRadius,
    required Offset offset,
    double spreadRadius = 0,
    double opacity = 1.0,
  }) {
    return [
      BoxShadow(
        color: color.withValues(alpha:opacity),
        blurRadius: blurRadius,
        offset: offset,
        spreadRadius: spreadRadius,
      ),
    ];
  }

  /// Create layered shadow (multiple shadows)
  static List<BoxShadow> layered({
    required List<Map<String, dynamic>> layers,
  }) {
    return layers.map((layer) {
      return BoxShadow(
        color: (layer['color'] as Color).withValues(alpha:layer['opacity'] ?? 1.0),
        blurRadius: layer['blurRadius'] ?? 0,
        offset: layer['offset'] ?? Offset.zero,
        spreadRadius: layer['spreadRadius'] ?? 0,
      );
    }).toList();
  }

  /// Get shadow by elevation level (0-24)
  static List<BoxShadow> byElevation(int elevation) {
    if (elevation <= 0) return none;
    if (elevation <= 1) return xs;
    if (elevation <= 2) return sm;
    if (elevation <= 4) return md;
    if (elevation <= 8) return lg;
    if (elevation <= 16) return xl;
    return xxl;
  }
}
