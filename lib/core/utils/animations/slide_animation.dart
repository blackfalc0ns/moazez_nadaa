import 'package:flutter/material.dart';

/// Slide animation widget
class SlideAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final Offset beginOffset;
  final bool animate;

  const SlideAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.delay = Duration.zero,
    this.curve = Curves.easeInOut,
    this.beginOffset = const Offset(0, 0.3),
    this.animate = true,
  });

  @override
  State<SlideAnimation> createState() => _SlideAnimationState();
}

class _SlideAnimationState extends State<SlideAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(begin: widget.beginOffset, end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
    if (widget.animate) {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.animate) return widget.child;
    return SlideTransition(position: _slideAnimation, child: widget.child);
  }
}

/// Slide from direction helper
enum SlideDirection { top, bottom, left, right }

class SlideFrom extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final SlideDirection direction;

  const SlideFrom({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.delay = Duration.zero,
    this.direction = SlideDirection.bottom,
  });

  @override
  Widget build(BuildContext context) {
    Offset offset;
    switch (direction) {
      case SlideDirection.top:
        offset = const Offset(0, -1);
        break;
      case SlideDirection.bottom:
        offset = const Offset(0, 1);
        break;
      case SlideDirection.left:
        offset = const Offset(-1, 0);
        break;
      case SlideDirection.right:
        offset = const Offset(1, 0);
        break;
    }

    return SlideAnimation(
      duration: duration,
      delay: delay,
      beginOffset: offset,
      child: child,
    );
  }
}