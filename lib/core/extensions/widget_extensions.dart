import 'package:flutter/material.dart';

/// Widget extensions providing utility methods for widget manipulation
extension WidgetExtensions on Widget {
  /// Wrap widget with padding
  Widget withPadding(EdgeInsetsGeometry padding) {
    return Padding(padding: padding, child: this);
  }

  /// Wrap widget with symmetric padding
  Widget withPaddingSymmetric({double horizontal = 0, double vertical = 0}) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical), child: this);
  }

  /// Wrap widget with padding from all sides
  Widget withPaddingAll(double padding) {
    return Padding(padding: EdgeInsets.all(padding), child: this);
  }

  /// Wrap widget with only left padding
  Widget withPaddingLeft(double padding) {
    return Padding(padding: EdgeInsets.only(left: padding), child: this);
  }

  /// Wrap widget with only right padding
  Widget withPaddingRight(double padding) {
    return Padding(padding: EdgeInsets.only(right: padding), child: this);
  }

  /// Wrap widget with only top padding
  Widget withPaddingTop(double padding) {
    return Padding(padding: EdgeInsets.only(top: padding), child: this);
  }

  /// Wrap widget with only bottom padding
  Widget withPaddingBottom(double padding) {
    return Padding(padding: EdgeInsets.only(bottom: padding), child: this);
  }

  /// Wrap widget with margin
  Widget withMargin(EdgeInsetsGeometry margin) {
    return Container(margin: margin, child: this);
  }

  /// Wrap widget with symmetric margin
  Widget withMarginSymmetric({double horizontal = 0, double vertical = 0}) {
    return Container(margin: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical), child: this);
  }

  /// Wrap widget with margin from all sides
  Widget withMarginAll(double margin) {
    return Container(margin: EdgeInsets.all(margin), child: this);
  }

  /// Center the widget
  Widget centered() {
    return Center(child: this);
  }

  /// Expand the widget
  Widget expanded() {
    return Expanded(child: this);
  }

  /// Wrap widget with alignment
  Widget aligned(AlignmentGeometry alignment) {
    return Align(alignment: alignment, child: this);
  }

  /// Wrap widget with flex
  Widget flex(int flex, {CrossAxisAlignment? crossAxisAlignment}) {
    return Expanded(
      flex: flex,
      child: this,
    );
  }

  /// Set widget opacity
  Widget opacity(double opacity) {
    return Opacity(opacity: opacity, child: this);
  }

  /// Make widget clickable
  Widget onTap(VoidCallback? onTap) {
    return InkWell(onTap: onTap, child: this);
  }

  /// Make widget clickable with splash
  Widget onTapSplash(void Function()? onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: this,
      ),
    );
  }

  /// Wrap widget with Card
  Widget card({
    Color? color,
    double? elevation,
    ShapeBorder? shape,
    EdgeInsetsGeometry? margin,
  }) {
    return Card(
      color: color,
      elevation: elevation ?? 2,
      shape: shape,
      margin: margin ?? EdgeInsets.zero,
      child: this,
    );
  }

  /// Wrap widget with border radius
  Widget rounded(double radius) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: this,
    );
  }

  /// Wrap widget with border
  Widget bordered({
    Color? color,
    double width = 1,
    double borderRadius = 0,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color ?? Colors.grey, width: width),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: this,
    );
  }

  /// Wrap widget with ColoredBox
  Widget withColor(Color color) {
    return ColoredBox(color: color, child: this);
  }

  /// Set widget visibility
  Widget visible(bool isVisible) {
    return isVisible ? this : const SizedBox.shrink();
  }

  /// Set widget to take full width
  Widget fullWidth() {
    return SizedBox(width: double.infinity, child: this);
  }

  /// Set widget to take full height
  Widget fullHeight() {
    return SizedBox(height: double.infinity, child: this);
  }

  /// Set widget size
  Widget size({double? width, double? height}) {
    return SizedBox(width: width, height: height, child: this);
  }

  /// Set minimum size constraints
  Widget withMinSize({double? minWidth, double? minHeight}) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth ?? 0, minHeight: minHeight ?? 0),
      child: this,
    );
  }

  /// Set maximum size constraints
  Widget withMaxSize({double? maxWidth, double? maxHeight}) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity, maxHeight: maxHeight ?? double.infinity),
      child: this,
    );
  }

  Widget gestureDetector({
    void Function()? onTap,
    void Function(TapDownDetails)? onTapDown,
    void Function(TapUpDetails)? onTapUp,
    void Function()? onTapCancel,
    void Function()? onLongPress,
  }) {
    return GestureDetector(
      onTap: onTap,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onLongPress: onLongPress,
      child: this,
    );
  }

  /// Wrap widget with animation
  Widget animated({
    required Duration duration,
    Curve curve = Curves.easeInOut,
    bool reverse = false,
  }) {
    return AnimatedSwitcher(
      duration: duration,
      child: this,
    );
  }
}

/// List of Widget extensions
extension WidgetListExtensions on List<Widget> {
  /// Add separator between widgets
  Widget joinWith(Widget separator) {
    if (isEmpty) return const SizedBox.shrink();
    final children = <Widget>[];
    for (int i = 0; i < length; i++) {
      children.add(this[i]);
      if (i < length - 1) {
        children.add(separator);
      }
    }
    return Row(children: children);
  }

  /// Create a row with widgets
  Widget toRow({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
  }) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: this,
    );
  }

  /// Create a column with widgets
  Widget toColumn({
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
  }) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: this,
    );
  }

  /// Wrap widgets in a Stack
  Widget toStack({
    StackFit fit = StackFit.loose,
    AlignmentGeometry alignment = AlignmentDirectional.topStart,
  }) {
    return Stack(
      fit: fit,
      alignment: alignment,
      children: this,
    );
  }
}