/// Layout breakpoints shared across the app.
///
/// Values follow Material 3 window-size guidance:
/// - [compact]  (0   – 600)   phones in portrait.
/// - [medium]   (600 – 840)   small tablets / large phones in landscape.
/// - [expanded] (840 – 1200)  large tablets / small desktop windows.
/// - ≥ 1200 is treated as `AppWindowClass.large` (desktop / web).
///
/// Prefer structural decisions against these widths instead of scattered
/// device-name checks. Feature-specific thresholds should stay inside that
/// feature and not be added here.
abstract final class AppBreakpoints {
  static const double compact = 600;
  static const double medium = 840;
  static const double expanded = 1200;

  /// Devices narrower than this need specially tuned compact layouts
  /// (e.g. very small phones, folded foldables).
  static const double narrowPhone = 360;

  /// Devices with a usable height below this are considered "short" and may
  /// need reduced vertical padding / smaller components.
  static const double shortHeight = 700;

  /// Maximum readable content widths per window class. Used to keep line
  /// lengths comfortable on wide screens instead of stretching edge to edge.
  static const double compactContentMax = 560;
  static const double mediumContentMax = 760;
  static const double expandedContentMax = 1120;

  /// Reference device used for proportional scaling helpers.
  ///
  /// `width / 390` and `height / 844` map the current size onto an iPhone 12/13
  /// (logical 390 × 844). The clamps in [ResponsiveInfo] keep the result in a
  /// sane range so visuals never get extreme on very small or very large
  /// devices.
  static const double referenceWidth = 390;
  static const double referenceHeight = 844;
}

/// The four coarse layout buckets derived from the available width.
enum AppWindowClass { compact, medium, expanded, large }
