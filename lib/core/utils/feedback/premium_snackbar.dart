import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart'
    show ContentType;
import 'package:ndaaa_chat/core/localization/app_localizations_ar.dart';

/// Premium modern snackbar system with custom animations and colors
/// Provides success, error, warning, and info feedback with beautiful animations
///
/// Features:
/// - ✅ Compact height & premium layout
/// - ✅ Smooth cubic entry animation from top
/// - ✅ Swipe horizontal to dismiss natively
/// - ✅ Dedicated "X" close button
/// - ✅ Harmonious modern colors with glassmorphic borders
///
class PremiumSnackbar {
  PremiumSnackbar._();

  /// Custom light green color for success (أخضر فاتح)
  static const Color _successColor = Color.fromARGB(255, 63, 146, 66);

  /// Show success snackbar
  static void success(
    BuildContext context, {
    required String message,
    String? title,
    Duration? duration,
    VoidCallback? onTap,
  }) {
    _showAnimatedSnackbar(
      context,
      title: title ?? AppLocalizationsAr.successTitle,
      message: message,
      contentType: ContentType.success,
      duration: duration,
      customColor: _successColor,
      onTap: onTap,
    );
  }

  /// Show error snackbar
  static void error(
    BuildContext context, {
    required String message,
    String? title,
    Duration? duration,
    VoidCallback? onRetry,
  }) {
    _showAnimatedSnackbar(
      context,
      title: title ?? AppLocalizationsAr.errorTitle,
      message: message,
      contentType: ContentType.failure,
      duration: duration,
      onTap: onRetry,
    );
  }

  /// Show warning snackbar
  static void warning(
    BuildContext context, {
    required String message,
    String? title,
    Duration? duration,
    VoidCallback? onTap,
  }) {
    _showAnimatedSnackbar(
      context,
      title: title ?? 'تحذير!',
      message: message,
      contentType: ContentType.warning,
      duration: duration,
      onTap: onTap,
    );
  }

  /// Show info snackbar
  static void info(
    BuildContext context, {
    required String message,
    String? title,
    Duration? duration,
    VoidCallback? onTap,
  }) {
    _showAnimatedSnackbar(
      context,
      title: title ?? 'معلومة!',
      message: message,
      contentType: ContentType.help,
      duration: duration,
      onTap: onTap,
    );
  }

  /// Internal method to show snackbar with custom animation
  static void _showAnimatedSnackbar(
    BuildContext context, {
    required String title,
    required String message,
    required ContentType contentType,
    Duration? duration,
    Color? customColor,
    VoidCallback? onTap,
  }) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _AnimatedSnackbarWidget(
        title: title,
        message: message,
        contentType: contentType,
        duration: duration ?? const Duration(seconds: 3),
        customColor: customColor,
        onTap: onTap,
        onDismiss: () {
          overlayEntry.remove();
        },
      ),
    );

    overlay.insert(overlayEntry);
  }

  /// Keep compatibility for showBanner/hideBanner if needed
  static void showBanner(
    BuildContext context, {
    required String title,
    required String message,
    required ContentType contentType,
  }) {
    // Left as compatibility wrapper
  }

  static void hideBanner(BuildContext context) {
    // Left as compatibility wrapper
  }
}

/// Animated snackbar widget with custom animations
class _AnimatedSnackbarWidget extends StatefulWidget {
  final String title;
  final String message;
  final ContentType contentType;
  final Duration duration;
  final Color? customColor;
  final VoidCallback? onTap;
  final VoidCallback onDismiss;

  const _AnimatedSnackbarWidget({
    required this.title,
    required this.message,
    required this.contentType,
    required this.duration,
    required this.onDismiss,
    this.customColor,
    this.onTap,
  });

  @override
  State<_AnimatedSnackbarWidget> createState() =>
      _AnimatedSnackbarWidgetState();
}

class _AnimatedSnackbarWidgetState extends State<_AnimatedSnackbarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isDismissed = false;

  @override
  void initState() {
    super.initState();

    // Create animation controller with smooth curve duration
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Smooth entry slide from top
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          ),
        );

    // Smooth fade transition
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );

    // Start entry animation
    _controller.forward();

    // Auto dismiss after duration
    Future.delayed(widget.duration, () {
      if (mounted && !_isDismissed) {
        _dismiss();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    if (_isDismissed) return;
    setState(() {
      _isDismissed = true;
    });
    await _controller.reverse();
    widget.onDismiss();
  }

  Color _getBgColor() {
    if (widget.customColor != null) return widget.customColor!;

    // Fallbacks matching typical ContentType
    final typeStr = widget.contentType.toString().toLowerCase();
    if (typeStr.contains('success')) {
      return const Color.fromARGB(255, 63, 146, 66); // Rich Green
    } else if (typeStr.contains('failure')) {
      return const Color(0xFFD32F2F); // Rich Red
    } else if (typeStr.contains('warning')) {
      return const Color(0xFFED6C02); // Rich Orange
    }
    return const Color(0xFF0288D1); // Royal Info Blue
  }

  IconData _getIcon() {
    final typeStr = widget.contentType.toString().toLowerCase();
    if (typeStr.contains('success')) {
      return Icons.check_circle_rounded;
    } else if (typeStr.contains('failure')) {
      return Icons.error_rounded;
    } else if (typeStr.contains('warning')) {
      return Icons.warning_rounded;
    }
    return Icons.info_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _getBgColor();
    final iconData = _getIcon();

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              child: Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.horizontal,
                onDismissed: (_) {
                  _isDismissed = true;
                  widget.onDismiss();
                },
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      if (widget.onTap != null) {
                        widget.onTap!();
                      }
                      _dismiss();
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Ink(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.24),
                            blurRadius: 18,
                            spreadRadius: 1,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(iconData, color: Colors.white, size: 26),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.message,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.92),
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: _dismiss,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
