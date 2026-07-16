import 'package:flutter/material.dart';

import '../responsive_info.dart';
import '../responsive_scope.dart';

typedef AdaptiveWidgetBuilder =
    Widget Function(BuildContext context, ResponsiveInfo info);

/// Picks one of several widget builders based on the current layout.
///
/// Selection order (first match wins):
///   1. [landscape] when the device is in landscape and provided.
///   2. [expanded] on expanded/large window classes when provided.
///   3. [medium] on the medium window class when provided.
///   4. [compact] as the always-available fallback.
///
/// Use this for *structural* differences (e.g. single column vs. two panes).
/// For simple numeric/token differences prefer [ResponsiveInfo.select].
class AdaptiveLayoutBuilder extends StatelessWidget {
  final AdaptiveWidgetBuilder compact;
  final AdaptiveWidgetBuilder? medium;
  final AdaptiveWidgetBuilder? expanded;
  final AdaptiveWidgetBuilder? landscape;

  const AdaptiveLayoutBuilder({
    super.key,
    required this.compact,
    this.medium,
    this.expanded,
    this.landscape,
  });

  @override
  Widget build(BuildContext context) {
    final info = context.responsive;
    if (info.isLandscape && landscape != null) {
      return landscape!(context, info);
    }
    if (info.isExpanded && expanded != null) {
      return expanded!(context, info);
    }
    if (info.isMedium && medium != null) {
      return medium!(context, info);
    }
    return compact(context, info);
  }
}
