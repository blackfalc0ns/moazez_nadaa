import 'package:flutter/material.dart';

import 'responsive_info.dart';

/// Provides a [ResponsiveInfo] to its descendants via an [InheritedWidget], so
/// widgets can read the current layout with `context.responsive` instead of
/// each calling `MediaQuery.of` themselves.
///
/// Wrap a subtree when you want layout decisions based on the size of a
/// specific region (e.g. inside a split pane or a bottom sheet) rather than the
/// whole screen. The global one installed in `main.dart` covers the navigator.
class ResponsiveScope extends StatelessWidget {
  final Widget Function(BuildContext context, ResponsiveInfo info) builder;

  const ResponsiveScope({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final info = ResponsiveInfo.fromContext(
          context,
          constraints: constraints,
        );
        return _ResponsiveInherited(info: info, child: builder(context, info));
      },
    );
  }
}

class _ResponsiveInherited extends InheritedWidget {
  final ResponsiveInfo info;

  const _ResponsiveInherited({required this.info, required super.child});

  @override
  bool updateShouldNotify(_ResponsiveInherited oldWidget) =>
      info.size != oldWidget.info.size ||
      info.orientation != oldWidget.info.orientation ||
      info.textScaleFactor != oldWidget.info.textScaleFactor ||
      info.viewPadding != oldWidget.info.viewPadding ||
      info.viewInsets != oldWidget.info.viewInsets ||
      info.displayFeatures != oldWidget.info.displayFeatures;
}

extension ResponsiveContext on BuildContext {
  /// The [ResponsiveInfo] for the nearest [ResponsiveScope], or a fresh
  /// [ResponsiveInfo.fromContext] snapshot when no scope is mounted above
  /// (e.g. in tests). Prefer always having a scope in production trees.
  ResponsiveInfo get responsive {
    final inherited =
        dependOnInheritedWidgetOfExactType<_ResponsiveInherited>();
    return inherited?.info ?? ResponsiveInfo.fromContext(this);
  }
}
