import 'package:flutter/material.dart';

import '../responsive_scope.dart';

/// Centers a child and constrains its width to a readable maximum, applying
/// [ResponsiveInfo.pagePadding] by default.
///
/// Use this to keep form fields, articles, and detail screens readable on
/// tablets/desktop instead of stretching edge to edge.
class ResponsiveConstrainedContent extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? maxWidth;
  final Alignment alignment;

  const ResponsiveConstrainedContent({
    super.key,
    required this.child,
    this.padding,
    this.maxWidth,
    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    final info = context.responsive;
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? info.contentMaxWidth),
        child: Padding(padding: padding ?? info.pagePadding, child: child),
      ),
    );
  }
}
