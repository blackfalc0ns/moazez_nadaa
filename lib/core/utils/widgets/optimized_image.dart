import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// A widget that displays an optimized image with caching, placeholder, and error handling.
/// Supports both network images and local file images with automatic optimization hints.
class OptimizedImage extends StatelessWidget {
  /// The image URL or file path.
  final String? imageUrl;

  /// Optional local file to display.
  final File? localFile;

  /// Image fit mode.
  final BoxFit fit;

  /// Width constraint.
  final double? width;

  /// Height constraint.
  final double? height;

  /// Border radius for clipping.
  final double? borderRadius;

  /// Placeholder widget shown while loading.
  final Widget? placeholder;

  /// Error widget shown when image fails to load.
  final Widget? errorWidget;

  /// Background color for placeholder and error states.
  final Color? backgroundColor;

  /// Enable memory cache for network images.
  final bool enableMemoryCache;

  /// Enable disk cache for network images.
  final bool enableDiskCache;

  /// Custom cache key for network images.
  final String? cacheKey;

  /// Decoding quality hint (0-100) for network images.
  final int? decodeQuality;

  const OptimizedImage({
    super.key,
    this.imageUrl,
    this.localFile,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.backgroundColor,
    this.enableMemoryCache = true,
    this.enableDiskCache = true,
    this.cacheKey,
    this.decodeQuality,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultPlaceholder = placeholder ??
        Container(
          color: backgroundColor ?? theme.colorScheme.surfaceContainerHighest,
          child: Center(
            child: Icon(
              Icons.image_outlined,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              size: 48,
            ),
          ),
        );

    final defaultErrorWidget = errorWidget ??
        Container(
          color: backgroundColor ?? theme.colorScheme.errorContainer,
          child: Center(
            child: Icon(
              Icons.broken_image_outlined,
              color: theme.colorScheme.onErrorContainer,
              size: 48,
            ),
          ),
        );

    Widget imageWidget;

    if (localFile != null && localFile!.existsSync()) {
      // Display local file image
      imageWidget = Image.file(
        localFile!,
        fit: fit,
        width: width,
        height: height,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: frame != null ? child : defaultPlaceholder,
          );
        },
        errorBuilder: (context, error, stackTrace) => defaultErrorWidget,
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      // Display network image with caching
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: fit,
        width: width,
        height: height,
        memCacheWidth: decodeQuality != null
            ? (width != null ? (width! * decodeQuality! / 100).toInt() : null)
            : null,
        memCacheHeight: decodeQuality != null
            ? (height != null
                ? (height! * decodeQuality! / 100).toInt()
                : null)
            : null,

        cacheKey: cacheKey,
        placeholder: (context, url) =>
            placeholder ?? defaultPlaceholder,
        errorWidget: (context, url, error) => defaultErrorWidget,
        fadeInDuration: const Duration(milliseconds: 200),
        fadeOutDuration: const Duration(milliseconds: 200),
      );
    } else {
      // No image source provided
      imageWidget = defaultErrorWidget;
    }

    // Apply border radius if specified
    if (borderRadius != null && borderRadius! > 0) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius!),
        child: SizedBox(
          width: width,
          height: height,
          child: imageWidget,
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: imageWidget,
    );
  }
}

/// An avatar-optimized image widget with circular cropping and initials fallback.
class OptimizedAvatar extends StatelessWidget {
  /// The image URL or file path.
  final String? imageUrl;

  /// Optional local file to display.
  final File? localFile;

  /// Avatar display name for initials fallback.
  final String? name;

  /// Avatar size.
  final double size;

  /// Background color for initials fallback.
  final Color? backgroundColor;

  /// Text style for initials.
  final TextStyle? textStyle;

  const OptimizedAvatar({
    super.key,
    this.imageUrl,
    this.localFile,
    this.name,
    this.size = 48,
    this.backgroundColor,
    this.textStyle,
  });

  String get _initials {
    if (name == null || name!.isEmpty) return '?';
    final parts = name!.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name![0].toUpperCase();
  }

  Color _getBackgroundColor(BuildContext context) {
    if (backgroundColor != null) return backgroundColor!;
    final theme = Theme.of(context);
    final colors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.colorScheme.tertiary,
      theme.colorScheme.error,
    ];
    if (name != null && name!.isNotEmpty) {
      return colors[name!.hashCode.abs() % colors.length];
    }
    return colors[0];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getBackgroundColor(context),
      ),
      child: ClipOval(
        child: OptimizedImage(
          imageUrl: imageUrl,
          localFile: localFile,
          fit: BoxFit.cover,
          width: size,
          height: size,
          backgroundColor: _getBackgroundColor(context),
          placeholder: Center(
            child: Text(
              _initials,
              style: textStyle ??
                  theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          errorWidget: Center(
            child: Text(
              _initials,
              style: textStyle ??
                  theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
