import 'package:flutter/material.dart';

/// Custom page route with animations
class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final PageTransitionType transitionType;

  CustomPageRoute({
    required this.page,
    this.transitionType = PageTransitionType.slideFromRight,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _buildTransition(animation, child, transitionType);
          },
          transitionDuration: const Duration(milliseconds: 300),
        );

  static Widget _buildTransition(
    Animation<double> animation,
    Widget child,
    PageTransitionType type,
  ) {
    switch (type) {
      case PageTransitionType.fade:
        return FadeTransition(opacity: animation, child: child);
      case PageTransitionType.scale:
        return ScaleTransition(scale: animation, child: child);
      case PageTransitionType.slideFromRight:
        final slideIn = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));
        return SlideTransition(position: slideIn, child: child);
      case PageTransitionType.slideFromLeft:
        final slideIn = Tween<Offset>(
          begin: const Offset(-1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));
        return SlideTransition(position: slideIn, child: child);
      case PageTransitionType.slideFromBottom:
        final slideIn = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));
        return SlideTransition(position: slideIn, child: child);
    }
  }
}

/// Page transition types
enum PageTransitionType {
  fade,
  scale,
  slideFromRight,
  slideFromLeft,
  slideFromBottom,
}

/// Navigate with custom transition
extension NavigateExtension on BuildContext {
  Future<T?> navigateTo<T>({
    required Widget page,
    PageTransitionType transitionType = PageTransitionType.slideFromRight,
  }) {
    return Navigator.push<T>(
      this,
      CustomPageRoute<T>(page: page, transitionType: transitionType),
    );
  }

  Future<T?> navigateToReplacement<T>({
    required Widget page,
    PageTransitionType transitionType = PageTransitionType.slideFromRight,
  }) {
    return Navigator.pushReplacement(
      this,
      CustomPageRoute<T>(page: page, transitionType: transitionType),
    );
  }

  void navigateAndClearStack(Widget page) {
    Navigator.pushAndRemoveUntil(
      this,
      CustomPageRoute(page: page),
      (route) => false,
    );
  }
}