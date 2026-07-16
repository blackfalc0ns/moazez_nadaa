import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app_breakpoints.dart';
import '../responsive_scope.dart';

/// Centers sliver content and keeps it readable on tablets and wide windows.
class ResponsiveSliverContent extends StatelessWidget {
  final Widget sliver;
  final double maxWidth;
  final double top;
  final double bottom;

  const ResponsiveSliverContent({
    super.key,
    required this.sliver,
    this.maxWidth = AppBreakpoints.expandedContentMax,
    this.top = 0,
    this.bottom = 0,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final centeredInset = (constraints.crossAxisExtent - maxWidth) / 2;
        final horizontal = math.max(responsive.pagePadding.left, centeredInset);
        return SliverPadding(
          padding: EdgeInsets.fromLTRB(horizontal, top, horizontal, bottom),
          sliver: sliver,
        );
      },
    );
  }
}
