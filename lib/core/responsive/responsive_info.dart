import 'dart:math' as math;
import 'dart:ui' show DisplayFeature, DisplayFeatureType, DisplayFeatureState;

import 'package:flutter/material.dart';

import 'app_breakpoints.dart';

/// Immutable snapshot of the layout information for the current [ResponsiveScope]
/// subtree.
///
/// A single instance is built by [ResponsiveScope] (or via [fromContext] as a
/// fallback) and exposed through `context.responsive`. It is intentionally a
/// plain value object: read it to make layout decisions, never store a long
/// lived reference to it.
@immutable
class ResponsiveInfo {
  final Size size;
  final EdgeInsets viewPadding;
  final EdgeInsets viewInsets;
  final Orientation orientation;
  final double textScaleFactor;
  final AppWindowClass windowClass;

  /// Display features such as hinge bounds on foldables. Used to avoid placing
  /// interactive content across the fold. Empty on regular phones/tablets.
  final List<DisplayFeature> displayFeatures;

  const ResponsiveInfo({
    required this.size,
    required this.viewPadding,
    required this.viewInsets,
    required this.orientation,
    required this.textScaleFactor,
    required this.windowClass,
    this.displayFeatures = const [],
  });

  factory ResponsiveInfo.fromContext(
    BuildContext context, {
    BoxConstraints? constraints,
  }) {
    final mediaQuery = MediaQuery.of(context);
    final constrainedSize = constraints == null
        ? mediaQuery.size
        : Size(
            constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : mediaQuery.size.width,
            constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : mediaQuery.size.height,
          );
    final width = constrainedSize.width;
    return ResponsiveInfo(
      size: constrainedSize,
      viewPadding: mediaQuery.viewPadding,
      viewInsets: mediaQuery.viewInsets,
      orientation: constrainedSize.width > constrainedSize.height
          ? Orientation.landscape
          : Orientation.portrait,
      textScaleFactor: mediaQuery.textScaler.scale(1),
      windowClass: width < AppBreakpoints.compact
          ? AppWindowClass.compact
          : width < AppBreakpoints.medium
          ? AppWindowClass.medium
          : width < AppBreakpoints.expanded
          ? AppWindowClass.expanded
          : AppWindowClass.large,
      displayFeatures: mediaQuery.displayFeatures,
    );
  }

  double get width => size.width;
  double get height => size.height;
  double get shortestSide => math.min(width, height);
  double get longestSide => math.max(width, height);
  double get safeHeight => height - viewPadding.vertical - viewInsets.vertical;

  bool get isPortrait => orientation == Orientation.portrait;
  bool get isLandscape => orientation == Orientation.landscape;
  bool get isCompact => windowClass == AppWindowClass.compact;
  bool get isMedium => windowClass == AppWindowClass.medium;
  bool get isExpanded =>
      windowClass == AppWindowClass.expanded ||
      windowClass == AppWindowClass.large;
  bool get isLarge => windowClass == AppWindowClass.large;
  bool get isNarrowPhone => width < AppBreakpoints.narrowPhone;
  bool get isShort => safeHeight < AppBreakpoints.shortHeight;

  /// Treats the device as a tablet when its shortest side is at least the
  /// compact breakpoint. Using the shortest side (instead of the width) keeps
  /// the classification stable when rotating, so a tablet stays a tablet in
  /// both portrait and landscape. Phablets very close to the boundary may
  /// classify either way; design layouts to work across the boundary instead
  /// of relying on a hard phone/tablet split.
  bool get isTablet => shortestSide >= AppBreakpoints.compact;

  /// Whether a master/detail (two-pane) layout is appropriate: landscape with
  /// enough width to render two readable panes side by side.
  bool get useTwoPaneLayout => isLandscape && width >= AppBreakpoints.compact;

  /// `true` when a foldable hinge separates the display. Use this (or
  /// [foldPadding]) to keep content away from the fold.
  bool get hasFold =>
      displayFeatures.any((f) => f.type == DisplayFeatureType.hinge);

  /// Padding that avoids the hinge area, or [EdgeInsets.zero] when there is no
  /// hinge. Use it to inset content that must not cross the fold. Only the
  /// side(s) the hinge actually crosses will be non-zero.
  EdgeInsets get foldPadding {
    final hinge = displayFeatures.firstWhere(
      (f) => f.type == DisplayFeatureType.hinge,
      orElse: () => const DisplayFeature(
        bounds: Rect.zero,
        type: DisplayFeatureType.unknown,
        state: DisplayFeatureState.unknown,
      ),
    );
    if (hinge.bounds == Rect.zero) return EdgeInsets.zero;
    return EdgeInsets.fromLTRB(
      hinge.bounds.left,
      hinge.bounds.top,
      width - hinge.bounds.right,
      height - hinge.bounds.bottom,
    );
  }

  /// Safe-area insets (status bar, notch, navigation bar) as an [EdgeInsets].
  /// Combine with [viewInsets] when you also need to dodge the keyboard.
  EdgeInsets get safeArea => viewPadding;

  /// Proportional width scale relative to an iPhone 12/13 reference
  /// (390 logical px). Clamped to keep visuals sane on extreme sizes.
  double get widthScale =>
      (width / AppBreakpoints.referenceWidth).clamp(0.82, 1.35);

  /// Proportional height scale relative to an iPhone 12/13 reference
  /// (844 logical px). Clamped to keep visuals sane on extreme sizes.
  double get heightScale =>
      (height / AppBreakpoints.referenceHeight).clamp(0.78, 1.25);

  /// The smaller of [widthScale] and [heightScale]; used by [scale] so a value
  /// never grows beyond what both dimensions can comfortably accommodate.
  double get balancedScale => math.min(widthScale, heightScale);

  /// Picks a value for the current [windowClass], falling back to the next
  /// smaller class when a more specific value is omitted.
  ///
  /// Prefer this generic version over [adaptive] when you need non-double
  /// values (colors, strings, widget subtrees, etc.).
  T select<T>({required T compact, T? medium, T? expanded, T? large}) {
    return switch (windowClass) {
      AppWindowClass.compact => compact,
      AppWindowClass.medium => medium ?? compact,
      AppWindowClass.expanded => expanded ?? medium ?? compact,
      AppWindowClass.large => large ?? expanded ?? medium ?? compact,
    };
  }

  /// Double-typed convenience wrapper around [select]. Identical behaviour,
  /// kept only because it reads more naturally for numeric tokens
  /// (`info.adaptive(compact: 16, medium: 24)`).
  double adaptive({
    required double compact,
    double? medium,
    double? expanded,
    double? large,
  }) => select(
    compact: compact,
    medium: medium,
    expanded: expanded,
    large: large,
  );

  /// Scales a visual value (icon size, spacing, dimension) by the smaller of
  /// the width/height scales, clamped to [minScale] / [maxScale].
  ///
  /// Use only for bounded visual details, never for whole-screen scaling.
  double scale(
    double value, {
    double minScale = 0.86,
    double maxScale = 1.22,
  }) => value * balancedScale.clamp(minScale, maxScale);

  /// Width-aware font size multiplier. The user's accessibility text scale
  /// ([textScaleFactor]) is **not** applied here — Flutter's text widgets
  /// already honour it — so this only accounts for width differences.
  double fontSize(
    double value, {
    double minScale = 0.92,
    double maxScale = 1.12,
  }) => value * widthScale.clamp(minScale, maxScale);

  double clampWidth(double fraction, {double min = 0, double max = 1200}) =>
      (width * fraction).clamp(min, max);

  double clampHeight(double fraction, {double min = 0, double max = 1200}) =>
      (height * fraction).clamp(min, max);

  /// Recommended page padding that grows with the window class.
  EdgeInsets get pagePadding => EdgeInsets.symmetric(
    horizontal: adaptive(compact: 16, medium: 24, expanded: 32, large: 40),
    vertical: adaptive(compact: 16, medium: 20, expanded: 24),
  );

  /// Recommended maximum content width to keep line lengths readable on wide
  /// screens. Pair with [ResponsiveConstrainedContent] or [pagePadding].
  double get contentMaxWidth => adaptive(
    compact: AppBreakpoints.compactContentMax,
    medium: AppBreakpoints.mediumContentMax,
    expanded: AppBreakpoints.expandedContentMax,
    large: AppBreakpoints.expandedContentMax,
  );

  ResponsiveInfo copyWith({
    Size? size,
    EdgeInsets? viewPadding,
    EdgeInsets? viewInsets,
    Orientation? orientation,
    double? textScaleFactor,
    AppWindowClass? windowClass,
    List<DisplayFeature>? displayFeatures,
  }) => ResponsiveInfo(
    size: size ?? this.size,
    viewPadding: viewPadding ?? this.viewPadding,
    viewInsets: viewInsets ?? this.viewInsets,
    orientation: orientation ?? this.orientation,
    textScaleFactor: textScaleFactor ?? this.textScaleFactor,
    windowClass: windowClass ?? this.windowClass,
    displayFeatures: displayFeatures ?? this.displayFeatures,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResponsiveInfo &&
          runtimeType == other.runtimeType &&
          size == other.size &&
          viewPadding == other.viewPadding &&
          viewInsets == other.viewInsets &&
          orientation == other.orientation &&
          textScaleFactor == other.textScaleFactor &&
          windowClass == other.windowClass &&
          _listEquals(displayFeatures, other.displayFeatures);

  @override
  int get hashCode => Object.hash(
    size,
    viewPadding,
    viewInsets,
    orientation,
    textScaleFactor,
    windowClass,
    Object.hashAll(displayFeatures),
  );

  bool _listEquals<T>(List<T> a, List<T> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
