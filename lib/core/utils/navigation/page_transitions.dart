import 'package:flutter/material.dart';
import 'package:ndaaa_chat/core/utils/navigation/custom_page_route.dart';

/// Page transition builder utility
class PageTransitions {
  PageTransitions._();

  /// Fade transition
  static Widget fadeTransition({
    required Animation<double> animation,
    required Widget child,
  }) {
    return FadeTransition(opacity: animation, child: child);
  }

  /// Scale transition
  static Widget scaleTransition({
    required Animation<double> animation,
    required Widget child,
  }) {
    return ScaleTransition(scale: animation, child: child);
  }

  /// Slide from right transition
  static Widget slideRightTransition({
    required Animation<double> animation,
    required Widget child,
  }) {
    final slideIn = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));
    return SlideTransition(position: slideIn, child: child);
  }

  /// Slide from left transition
  static Widget slideLeftTransition({
    required Animation<double> animation,
    required Widget child,
  }) {
    final slideIn = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));
    return SlideTransition(position: slideIn, child: child);
  }

  /// Slide from bottom transition
  static Widget slideBottomTransition({
    required Animation<double> animation,
    required Widget child,
  }) {
    final slideIn = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));
    return SlideTransition(position: slideIn, child: child);
  }

  /// Slide from top transition
  static Widget slideTopTransition({
    required Animation<double> animation,
    required Widget child,
  }) {
    final slideIn = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));
    return SlideTransition(position: slideIn, child: child);
  }

  /// Rotation transition
  static Widget rotationTransition({
    required Animation<double> animation,
    required Widget child,
  }) {
    return RotationTransition(turns: animation, child: child);
  }

  /// Combined scale and fade transition
  static Widget scaleFadeTransition({
    required Animation<double> animation,
    required Widget child,
  }) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(scale: animation, child: child),
    );
  }
}

/// Custom page transitions builder
class CustomPageTransitionsBuilder extends PageTransitionsBuilder {
  final PageTransitionType transitionType;

  const CustomPageTransitionsBuilder({
    this.transitionType = PageTransitionType.slideFromRight,
  });

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    switch (transitionType) {
      case PageTransitionType.fade:
        return PageTransitions.fadeTransition(
          animation: animation,
          child: child,
        );
      case PageTransitionType.scale:
        return PageTransitions.scaleTransition(
          animation: animation,
          child: child,
        );
      case PageTransitionType.slideFromRight:
        return PageTransitions.slideRightTransition(
          animation: animation,
          child: child,
        );
      case PageTransitionType.slideFromLeft:
        return PageTransitions.slideLeftTransition(
          animation: animation,
          child: child,
        );
      case PageTransitionType.slideFromBottom:
        return PageTransitions.slideBottomTransition(
          animation: animation,
          child: child,
        );
    }
  }
}
