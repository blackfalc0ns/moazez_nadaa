import 'package:flutter/material.dart';

/// A non-scrolling grid that derives its column count from the available width
/// and a minimum item width.
///
/// This wraps children in a [Wrap], so it is best suited for short lists of
/// items that fit on screen. For long, scrollable lists use a `SliverGrid`
/// (e.g. `SliverGridDelegateWithMaxCrossAxisExtent`) instead.
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double minItemWidth;
  final double spacing;
  final double runSpacing;

  /// Lower bound for the calculated column count (defaults to 1).
  final int minColumns;

  /// Upper bound for the calculated column count (defaults to 6, enough for
  /// most dashboards; pass a larger value if you genuinely need more).
  final int maxColumns;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.minItemWidth = 280,
    this.spacing = 16,
    this.runSpacing = 16,
    this.minColumns = 1,
    this.maxColumns = 6,
  }) : assert(minColumns >= 1),
       assert(maxColumns >= minColumns);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final calculated =
            ((constraints.maxWidth + spacing) / (minItemWidth + spacing))
                .floor()
                .clamp(minColumns, maxColumns);
        final cols = calculated;
        final width = cols <= 1
            ? constraints.maxWidth
            : (constraints.maxWidth - (spacing * (cols - 1))) / cols;
        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children
              .map((child) => SizedBox(width: width, child: child))
              .toList(),
        );
      },
    );
  }
}
