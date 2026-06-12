import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized typography system for the application
///
/// Provides consistent text styles across the app
class FontConstant {
  static const String cairo = "Cairo";
}

class AppTypography {
  AppTypography._();

  // ==================== HEADINGS ====================

  /// Heading 1 - Largest heading (32px, Bold)
  /// Use for: Main page titles, hero sections
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
    fontFamily: FontConstant.cairo,
  );

  /// Heading 2 - Large heading (28px, Bold)
  /// Use for: Section titles, important headers
  static const TextStyle heading2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.3,
    fontFamily: FontConstant.cairo,
  );

  /// Heading 3 - Medium heading (24px, SemiBold)
  /// Use for: Card titles, subsection headers
  static const TextStyle heading3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.2,
    fontFamily: FontConstant.cairo,
  );

  /// Heading 4 - Small heading (20px, SemiBold)
  /// Use for: List headers, dialog titles
  static const TextStyle heading4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0,
    fontFamily: FontConstant.cairo,
  );

  /// Heading 5 - Extra small heading (18px, SemiBold)
  /// Use for: Widget titles, small section headers
  static const TextStyle heading5 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 0,
    fontFamily: FontConstant.cairo,
  );

  /// Heading 6 - Smallest heading (16px, SemiBold)
  /// Use for: Inline headers, emphasized text
  static const TextStyle heading6 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    height: 1.5,
    letterSpacing: 0,
    fontFamily: FontConstant.cairo,
  );

  // ==================== BODY TEXT ====================

  /// Body Large - Large body text (16px, Regular)
  /// Use for: Main content, descriptions
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.15,
    fontFamily: FontConstant.cairo,
  );

  /// Body Medium - Medium body text (14px, Regular)
  /// Use for: Secondary content, list items
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.25,
    fontFamily: FontConstant.cairo,
  );

  /// Body Small - Small body text (12px, Regular)
  /// Use for: Helper text, metadata
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.4,
    fontFamily: FontConstant.cairo,
  );

  // ==================== LABELS ====================

  /// Label Large - Large label (14px, Medium)
  /// Use for: Button text, form labels
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
    fontFamily: FontConstant.cairo,
  );

  /// Label Medium - Medium label (12px, Medium)
  /// Use for: Chips, badges, small buttons
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.5,
    fontFamily: FontConstant.cairo,
  );

  /// Label Small - Small label (11px, Medium)
  /// Use for: Tiny labels, status indicators
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.5,
    fontFamily: FontConstant.cairo,
  );

  // ==================== CAPTIONS ====================

  /// Caption - Caption text (12px, Regular)
  /// Use for: Image captions, footnotes
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.3,
    letterSpacing: 0.4,
    fontFamily: FontConstant.cairo,
  );

  /// Overline - Overline text (10px, Medium, Uppercase)
  /// Use for: Category labels, timestamps
  static const TextStyle overline = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.6,
    letterSpacing: 1.5,
    fontFamily: FontConstant.cairo,
  );

  // ==================== SPECIALIZED ====================

  /// Button Text - Button text style (14px, SemiBold)
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0.5,
    fontFamily: FontConstant.cairo,
  );

  /// Link Text - Hyperlink style (14px, Medium, Underlined)
  static const TextStyle link = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.25,
    decoration: TextDecoration.underline,
    fontFamily: FontConstant.cairo,
  );

  /// Error Text - Error message style (12px, Regular)
  static const TextStyle error = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.4,
    color: AppColors.error,
    fontFamily: FontConstant.cairo,
  );

  // ==================== HELPER METHODS ====================

  /// Apply color to any text style
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Apply weight to any text style
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  /// Apply size to any text style
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }

  /// Apply height to any text style
  static TextStyle withHeight(TextStyle style, double height) {
    return style.copyWith(height: height);
  }

  /// Apply letter spacing to any text style
  static TextStyle withLetterSpacing(TextStyle style, double spacing) {
    return style.copyWith(letterSpacing: spacing);
  }
}
