import 'package:flutter/material.dart';

/// Custom animations for the application
class CustomAnimations {
  CustomAnimations._();

  // Standard animation durations
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);

  // Standard animation curves
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve accelerateCurve = Curves.easeOutCubic;
  static const Curve decelerateCurve = Curves.easeInCubic;

  /// Fade in animation
  static Animation<double> fadeIn({
    required AnimationController controller,
    Duration duration = normal,
    Curve curve = defaultCurve,
  }) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }

  /// Fade out animation
  static Animation<double> fadeOut({
    required AnimationController controller,
    Duration duration = normal,
    Curve curve = defaultCurve,
  }) {
    return Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }

  /// Slide from bottom animation
  static Animation<Offset> slideFromBottom({
    required AnimationController controller,
    Duration duration = normal,
    Curve curve = defaultCurve,
    Offset beginOffset = const Offset(0, 1),
  }) {
    return Tween<Offset>(begin: beginOffset, end: Offset.zero).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }

  /// Slide from top animation
  static Animation<Offset> slideFromTop({
    required AnimationController controller,
    Duration duration = normal,
    Curve curve = defaultCurve,
  }) {
    return Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }

  /// Slide from left animation
  static Animation<Offset> slideFromLeft({
    required AnimationController controller,
    Duration duration = normal,
    Curve curve = defaultCurve,
  }) {
    return Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }

  /// Slide from right animation
  static Animation<Offset> slideFromRight({
    required AnimationController controller,
    Duration duration = normal,
    Curve curve = defaultCurve,
  }) {
    return Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }

  /// Scale animation
  static Animation<double> scale({
    required AnimationController controller,
    Duration duration = normal,
    Curve curve = defaultCurve,
    double beginScale = 0.0,
    double endScale = 1.0,
  }) {
    return Tween<double>(begin: beginScale, end: endScale).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }

  /// Rotation animation
  static Animation<double> rotation({
    required AnimationController controller,
    Duration duration = normal,
    Curve curve = defaultCurve,
    double beginRotation = 0.0,
    double endRotation = 1.0,
  }) {
    return Tween<double>(begin: beginRotation, end: endRotation).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }

  /// Staggered animation helper
  static Animation<double> stagger({
    required AnimationController controller,
    required int index,
    int totalItems = 10,
    Duration itemDuration = fast,
  }) {
    final start = index / totalItems;
    final end = start + 0.3;
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(start, end.clamp(0.0, 1.0), curve: defaultCurve),
      ),
    );
  }
}

/// Animated widget that fades in
class FadeInWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;

  const FadeInWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.delay = Duration.zero,
    this.curve = Curves.easeInOut,
  });

  @override
  State<FadeInWidget> createState() => _FadeInWidgetState();
}

class _FadeInWidgetState extends State<FadeInWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _animation, child: widget.child);
  }
}