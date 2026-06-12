import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ndaaa_chat/core/theme/app_colors.dart';

class LogoShimmerLoader extends StatefulWidget {
  final double size;

  const LogoShimmerLoader({super.key, this.size = 140});

  @override
  State<LogoShimmerLoader> createState() => _LogoShimmerLoaderState();
}

class _LogoShimmerLoaderState extends State<LogoShimmerLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Animate a moving shine band across the logo
          final center = _controller.value; // 0..1
          final start = (center - 0.25).clamp(0.0, 1.0);
          final mid = center.clamp(0.0, 1.0);
          final end = (center + 0.25).clamp(0.0, 1.0);

          return ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.primary.withValues(alpha: 0.05),
                  AppColors.primary,
                  AppColors.secondary,
                  AppColors.primary.withValues(alpha: 0.05),
                ],
                stops: [start, mid, end, 1.0],
              ).createShader(rect);
            },
            blendMode: BlendMode.srcATop,
            child: child,
          );
        },
        child: SvgPicture.asset(
          'assets/images/logo.svg',
          height: widget.size,
          width: widget.size,
        ),
      ),
    );
  }
}
