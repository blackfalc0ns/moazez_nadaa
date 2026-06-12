import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Context extensions providing quick access to common properties and methods
extension ContextExtensions on BuildContext {
  /// Get MediaQueryData from the context
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Get screen width
  double get screenWidth => mediaQuery.size.width;

  /// Get screen height
  double get screenHeight => mediaQuery.size.height;

  /// Get safe area padding
  EdgeInsets get safeAreaPadding => mediaQuery.padding;

  /// Get bottom safe area (for devices with bottom navigation)
  double get bottomSafeArea => safeAreaPadding.bottom;

  /// Get top safe area (for devices with notch)
  double get topSafeArea => safeAreaPadding.top;

  /// Check if device is in landscape mode
  bool get isLandscape => mediaQuery.orientation == Orientation.landscape;

  /// Check if device is in portrait mode
  bool get isPortrait => mediaQuery.orientation == Orientation.portrait;

  /// Check if device is a tablet (width > 600)
  bool get isTablet => screenWidth >= 600;

  /// Check if device is a phone (width < 600)
  bool get isPhone => screenWidth < 600;

  /// Check if device is a desktop (width > 1200)
  bool get isDesktop => screenWidth >= 1200;

  /// Get device pixel ratio
  double get devicePixelRatio => mediaQuery.devicePixelRatio;

  /// Get text scale factor
  double get textScaleFactor => mediaQuery.textScaler.scale(1.0);

  /// Get current theme
  ThemeData get theme => Theme.of(this);

  /// Get current color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Get current text theme
  TextTheme get textTheme => theme.textTheme;

  /// Check if dark mode is enabled
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Get current locale
  Locale get locale => Localizations.localeOf(this);

  /// Check if current locale is RTL
  bool get isRtl => Directionality.of(this) == TextDirection.rtl;

  /// Check if current locale is Arabic
  bool get isArabic => locale.languageCode == 'ar';

  /// Get directional padding based on text direction
  EdgeInsets get directionalPadding {
    if (isRtl) {
      return EdgeInsets.only(left: safeAreaPadding.left);
    }
    return EdgeInsets.only(right: safeAreaPadding.right);
  }

  /// Show snackbar with message
  void showSnackBar(String message, {bool isError = false, Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
        duration: duration ?? const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Hide keyboard
  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }

  /// Request focus and show keyboard for given focus node
  void showKeyboard(FocusNode focusNode) {
    focusNode.requestFocus();
  }

  /// Pop navigation
  void pop<T>([T? result]) => Navigator.of(this).pop(result);

  /// Push new route
  Future<T?> push<T>(Widget page, {RouteSettings? settings}) {
    return Navigator.of(this).push<T>(
      MaterialPageRoute(builder: (_) => page, settings: settings),
    );
  }

  /// Push and remove all previous routes
  void pushAndRemoveAll(Widget page) {
    Navigator.of(this).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  /// Push named route
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
  }

  /// Push named route and remove all previous
  void pushNamedAndRemoveAll(String routeName, {Object? arguments}) {
    Navigator.of(this).pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Check if can pop
  bool get canPop => Navigator.of(this).canPop();

  /// Get arguments from route
  dynamic get routeArguments => ModalRoute.of(this)?.settings.arguments;

  /// Show confirmation dialog
  Future<bool?> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Yes',
    String cancelText = 'No',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: isDestructive
                ? TextButton.styleFrom(foregroundColor: Colors.red)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Copy to clipboard
  Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    showSnackBar('Copied to clipboard');
  }
}