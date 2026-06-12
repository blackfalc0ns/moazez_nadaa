import 'package:flutter/material.dart';

/// Centralized spacing system for consistent layouts
/// Provides standardized spacing values across the app
class AppSpacing {
  AppSpacing._();

  // ==================== SPACING VALUES ====================

  /// Extra extra small spacing (2px)
  static const double xxs = 2.0;

  /// Extra small spacing (4px)
  static const double xs = 4.0;

  /// Small spacing (8px)
  static const double sm = 8.0;

  /// Medium spacing (12px)
  static const double md = 12.0;

  /// Large spacing (16px)
  static const double lg = 16.0;

  /// Extra large spacing (24px)
  static const double xl = 24.0;

  /// Extra extra large spacing (32px)
  static const double xxl = 32.0;

  /// Extra extra extra large spacing (48px)
  static const double xxxl = 48.0;

  /// Huge spacing (64px)
  static const double huge = 64.0;
  
  /// Massive spacing (128px)
  static const double massive = 138.0;

  // ==================== EDGE INSETS ====================

  /// Zero padding
  static const EdgeInsets zero = EdgeInsets.zero;

  /// All sides - XXS (2px)
  static const EdgeInsets allXxs = EdgeInsets.all(xxs);

  /// All sides - XS (4px)
  static const EdgeInsets allXs = EdgeInsets.all(xs);

  /// All sides - SM (8px)
  static const EdgeInsets allSm = EdgeInsets.all(sm);

  /// All sides - MD (12px)
  static const EdgeInsets allMd = EdgeInsets.all(md);

  /// All sides - LG (16px)
  static const EdgeInsets allLg = EdgeInsets.all(lg);

  /// All sides - XL (24px)
  static const EdgeInsets allXl = EdgeInsets.all(xl);

  /// All sides - XXL (32px)
  static const EdgeInsets allXxl = EdgeInsets.all(xxl);

  // ==================== HORIZONTAL PADDING ====================

  /// Horizontal - XS (4px)
  static const EdgeInsets horizontalXs = EdgeInsets.symmetric(horizontal: xs);

  /// Horizontal - SM (8px)
  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(horizontal: sm);

  /// Horizontal - MD (12px)
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);

  /// Horizontal - LG (16px)
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: lg);

  /// Horizontal - XL (24px)
  static const EdgeInsets horizontalXl = EdgeInsets.symmetric(horizontal: xl);

  /// Horizontal - XXL (32px)
  static const EdgeInsets horizontalXxl = EdgeInsets.symmetric(horizontal: xxl);

  // ==================== VERTICAL PADDING ====================

  /// Vertical - XS (4px)
  static const EdgeInsets verticalXs = EdgeInsets.symmetric(vertical: xs);

  /// Vertical - SM (8px)
  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: sm);

  /// Vertical - MD (12px)
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);

  /// Vertical - LG (16px)
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: lg);

  /// Vertical - XL (24px)
  static const EdgeInsets verticalXl = EdgeInsets.symmetric(vertical: xl);

  /// Vertical - XXL (32px)
  static const EdgeInsets verticalXxl = EdgeInsets.symmetric(vertical: xxl);

  // ==================== COMMON PATTERNS ====================

  /// Page padding (horizontal: 16px, vertical: 24px)
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: xl,
  );

  /// Card padding (all: 16px)
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);

  /// List item padding (horizontal: 16px, vertical: 12px)
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  /// Button padding (horizontal: 24px, vertical: 12px)
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: md,
  );

  /// Dialog padding (all: 24px)
  static const EdgeInsets dialogPadding = EdgeInsets.all(xl);

  /// Bottom sheet padding (horizontal: 16px, vertical: 24px)
  static const EdgeInsets bottomSheetPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: xl,
  );

  /// Screen edge padding (all: 16px)
  static const EdgeInsets screenPadding = EdgeInsets.all(lg);

  /// Section padding (vertical: 24px)
  static const EdgeInsets sectionPadding = EdgeInsets.symmetric(vertical: xl);

  // ==================== SIZED BOXES ====================

  /// Vertical space - XXS (2px)
  static const SizedBox verticalSpaceXxs = SizedBox(height: xxs);

  /// Vertical space - XS (4px)
  static const SizedBox verticalSpaceXs = SizedBox(height: xs);

  /// Vertical space - SM (8px)
  static const SizedBox verticalSpaceSm = SizedBox(height: sm);

  /// Vertical space - MD (12px)
  static const SizedBox verticalSpaceMd = SizedBox(height: md);

  /// Vertical space - LG (16px)
  static const SizedBox verticalSpaceLg = SizedBox(height: lg);

  /// Vertical space - XL (24px)
  static const SizedBox verticalSpaceXl = SizedBox(height: xl);

  /// Vertical space - XXL (32px)
  static const SizedBox verticalSpaceXxl = SizedBox(height: xxl);

  /// Vertical space - XXXL (48px)
  static const SizedBox verticalSpaceXxxl = SizedBox(height: xxxl);

  /// Horizontal space - XXS (2px)
  static const SizedBox horizontalSpaceXxs = SizedBox(width: xxs);

  /// Horizontal space - XS (4px)
  static const SizedBox horizontalSpaceXs = SizedBox(width: xs);

  /// Horizontal space - SM (8px)
  static const SizedBox horizontalSpaceSm = SizedBox(width: sm);

  /// Horizontal space - MD (12px)
  static const SizedBox horizontalSpaceMd = SizedBox(width: md);

  /// Horizontal space - LG (16px)
  static const SizedBox horizontalSpaceLg = SizedBox(width: lg);

  /// Horizontal space - XL (24px)
  static const SizedBox horizontalSpaceXl = SizedBox(width: xl);

  /// Horizontal space - XXL (32px)
  static const SizedBox horizontalSpaceXxl = SizedBox(width: xxl);

  // ==================== HELPER METHODS ====================

  /// Create custom vertical space
  static SizedBox verticalSpace(double height) => SizedBox(height: height);

  /// Create custom horizontal space
  static SizedBox horizontalSpace(double width) => SizedBox(width: width);

  /// Create custom padding
  static EdgeInsets custom({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    if (all != null) {
      return EdgeInsets.all(all);
    }
    if (horizontal != null || vertical != null) {
      return EdgeInsets.symmetric(
        horizontal: horizontal ?? 0,
        vertical: vertical ?? 0,
      );
    }
    return EdgeInsets.only(
      top: top ?? 0,
      bottom: bottom ?? 0,
      left: left ?? 0,
      right: right ?? 0,
    );
  }

  /// Create symmetric padding
  static EdgeInsets symmetric({double? horizontal, double? vertical}) {
    return EdgeInsets.symmetric(
      horizontal: horizontal ?? 0,
      vertical: vertical ?? 0,
    );
  }

  /// Create padding with only specific sides
  static EdgeInsets only({
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return EdgeInsets.only(
      top: top ?? 0,
      bottom: bottom ?? 0,
      left: left ?? 0,
      right: right ?? 0,
    );
  }
}
