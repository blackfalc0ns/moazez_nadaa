import 'package:flutter/material.dart';

/// Centralized animation duration system
/// Provides consistent timing across all animations
class AppDurations {
  AppDurations._();

  // ==================== STANDARD DURATIONS ====================

  /// Instant - No animation (0ms)
  static const Duration instant = Duration.zero;

  /// Extra fast - Very quick animations (100ms)
  /// Use for: Micro-interactions, hover effects
  static const Duration extraFast = Duration(milliseconds: 100);

  /// Fast - Quick animations (200ms)
  /// Use for: Button presses, simple transitions
  static const Duration fast = Duration(milliseconds: 200);

  /// Normal - Standard animations (300ms)
  /// Use for: Most UI transitions, page changes
  static const Duration normal = Duration(milliseconds: 300);

  /// Medium - Moderate animations (400ms)
  /// Use for: Complex transitions, modal appearances
  static const Duration medium = Duration(milliseconds: 400);

  /// Slow - Slower animations (500ms)
  /// Use for: Emphasized transitions, important changes
  static const Duration slow = Duration(milliseconds: 500);

  /// Extra slow - Very slow animations (700ms)
  /// Use for: Hero animations, dramatic effects
  static const Duration extraSlow = Duration(milliseconds: 700);

  // ==================== SPECIFIC USE CASES ====================

  /// Button press animation
  static const Duration buttonPress = Duration(milliseconds: 150);

  /// Button release animation
  static const Duration buttonRelease = Duration(milliseconds: 200);

  /// Ripple effect duration
  static const Duration ripple = Duration(milliseconds: 300);

  /// Page transition duration
  static const Duration pageTransition = Duration(milliseconds: 350);

  /// Dialog appearance
  static const Duration dialogShow = Duration(milliseconds: 300);

  /// Dialog dismissal
  static const Duration dialogHide = Duration(milliseconds: 250);

  /// Bottom sheet slide up
  static const Duration bottomSheetUp = Duration(milliseconds: 350);

  /// Bottom sheet slide down
  static const Duration bottomSheetDown = Duration(milliseconds: 300);

  /// Snackbar appearance
  static const Duration snackbarShow = Duration(milliseconds: 250);

  /// Snackbar dismissal
  static const Duration snackbarHide = Duration(milliseconds: 200);

  /// Snackbar display time
  static const Duration snackbarDisplay = Duration(seconds: 3);

  /// Tooltip appearance
  static const Duration tooltipShow = Duration(milliseconds: 150);

  /// Tooltip dismissal
  static const Duration tooltipHide = Duration(milliseconds: 100);

  /// Dropdown menu open
  static const Duration dropdownOpen = Duration(milliseconds: 250);

  /// Dropdown menu close
  static const Duration dropdownClose = Duration(milliseconds: 200);

  /// Drawer slide in
  static const Duration drawerOpen = Duration(milliseconds: 300);

  /// Drawer slide out
  static const Duration drawerClose = Duration(milliseconds: 250);

  /// Tab switch animation
  static const Duration tabSwitch = Duration(milliseconds: 300);

  /// Scroll animation
  static const Duration scroll = Duration(milliseconds: 400);

  /// Fade in animation
  static const Duration fadeIn = Duration(milliseconds: 300);

  /// Fade out animation
  static const Duration fadeOut = Duration(milliseconds: 250);

  /// Scale up animation
  static const Duration scaleUp = Duration(milliseconds: 250);

  /// Scale down animation
  static const Duration scaleDown = Duration(milliseconds: 200);

  /// Slide in animation
  static const Duration slideIn = Duration(milliseconds: 300);

  /// Slide out animation
  static const Duration slideOut = Duration(milliseconds: 250);

  /// Rotate animation
  static const Duration rotate = Duration(milliseconds: 400);

  /// Shimmer animation cycle
  static const Duration shimmer = Duration(milliseconds: 1500);

  /// Loading indicator rotation
  static const Duration loadingRotation = Duration(milliseconds: 1000);

  /// Pull to refresh animation
  static const Duration pullToRefresh = Duration(milliseconds: 300);

  /// Swipe to dismiss
  static const Duration swipeToDismiss = Duration(milliseconds: 250);

  /// Expansion tile expand
  static const Duration expansionExpand = Duration(milliseconds: 300);

  /// Expansion tile collapse
  static const Duration expansionCollapse = Duration(milliseconds: 250);

  /// Search bar expand
  static const Duration searchExpand = Duration(milliseconds: 300);

  /// Search bar collapse
  static const Duration searchCollapse = Duration(milliseconds: 250);

  /// Image fade in
  static const Duration imageFadeIn = Duration(milliseconds: 300);

  /// Skeleton loading pulse
  static const Duration skeletonPulse = Duration(milliseconds: 1200);

  // ==================== DELAYS ====================

  /// No delay
  static const Duration noDelay = Duration.zero;

  /// Short delay (100ms)
  static const Duration shortDelay = Duration(milliseconds: 100);

  /// Medium delay (200ms)
  static const Duration mediumDelay = Duration(milliseconds: 200);

  /// Long delay (500ms)
  static const Duration longDelay = Duration(milliseconds: 500);

  /// Stagger delay for list items (50ms)
  static const Duration staggerDelay = Duration(milliseconds: 50);

  // ==================== DEBOUNCE DURATIONS ====================

  /// Search input debounce
  static const Duration searchDebounce = Duration(milliseconds: 500);

  /// Form validation debounce
  static const Duration validationDebounce = Duration(milliseconds: 300);

  /// API call debounce
  static const Duration apiDebounce = Duration(milliseconds: 800);

  /// Scroll debounce
  static const Duration scrollDebounce = Duration(milliseconds: 200);

  // ==================== TIMEOUT DURATIONS ====================

  /// Short timeout (5 seconds)
  static const Duration shortTimeout = Duration(seconds: 5);

  /// Medium timeout (10 seconds)
  static const Duration mediumTimeout = Duration(seconds: 10);

  /// Long timeout (30 seconds)
  static const Duration longTimeout = Duration(seconds: 30);

  /// API request timeout (30 seconds)
  static const Duration apiTimeout = Duration(seconds: 30);

  /// File upload timeout (2 minutes)
  static const Duration uploadTimeout = Duration(minutes: 2);

  /// File download timeout (5 minutes)
  static const Duration downloadTimeout = Duration(minutes: 5);

  // ==================== HELPER METHODS ====================

  /// Create custom duration from milliseconds
  static Duration milliseconds(int ms) => Duration(milliseconds: ms);

  /// Create custom duration from seconds
  static Duration seconds(int s) => Duration(seconds: s);

  /// Create custom duration from minutes
  static Duration minutes(int m) => Duration(minutes: m);

  /// Multiply duration by factor
  static Duration multiply(Duration duration, double factor) {
    return Duration(
      microseconds: (duration.inMicroseconds * factor).round(),
    );
  }

  /// Add two durations
  static Duration add(Duration a, Duration b) => a + b;

  /// Get duration for staggered animation
  /// [index] - Item index in list
  /// [baseDelay] - Base delay between items
  static Duration staggered(int index, {Duration? baseDelay}) {
    final delay = baseDelay ?? staggerDelay;
    return Duration(milliseconds: delay.inMilliseconds * index);
  }

  /// Get duration based on distance (for scroll animations)
  /// [distance] - Distance in pixels
  /// [pixelsPerSecond] - Animation speed
  static Duration fromDistance(double distance, {double pixelsPerSecond = 1000}) {
    final seconds = distance / pixelsPerSecond;
    return Duration(milliseconds: (seconds * 1000).round());
  }
}

/// Animation curves for consistent easing
class AppCurves {
  AppCurves._();

  /// Standard ease in out curve
  static const Curve easeInOut = Curves.easeInOut;

  /// Ease in curve
  static const Curve easeIn = Curves.easeIn;

  /// Ease out curve
  static const Curve easeOut = Curves.easeOut;

  /// Fast out slow in (Material Design standard)
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;

  /// Linear curve (no easing)
  static const Curve linear = Curves.linear;

  /// Bounce effect
  static const Curve bounce = Curves.bounceOut;

  /// Elastic effect
  static const Curve elastic = Curves.elasticOut;

  /// Decelerate curve
  static const Curve decelerate = Curves.decelerate;

  /// Accelerate curve
  static const Curve accelerate = Curves.fastLinearToSlowEaseIn;

  /// Emphasized curve (Material 3)
  static const Curve emphasized = Curves.easeInOutCubicEmphasized;

  /// Emphasized decelerate (Material 3)
  static const Curve emphasizedDecelerate = Curves.easeOutCubic;

  /// Emphasized accelerate (Material 3)
  static const Curve emphasizedAccelerate = Curves.easeInCubic;
}
