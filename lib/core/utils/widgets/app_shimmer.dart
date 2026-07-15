import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';

class AppShimmer extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  const AppShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  factory AppShimmer.box({
    Key? key,
    double? width,
    required double height,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? margin,
  }) {
    return AppShimmer(
      key: key,
      child: Container(
        width: width ?? double.infinity,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: borderRadius ?? AppRadius.circularSm,
        ),
      ),
    );
  }

  factory AppShimmer.circle({
    Key? key,
    required double size,
    EdgeInsetsGeometry? margin,
  }) {
    return AppShimmer(
      key: key,
      child: Container(
        width: size,
        height: size,
        margin: margin,
        decoration: const BoxDecoration(
          color: AppColors.surfaceLight,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = widget.baseColor ?? const Color(0xFFE2E8F0);
    final highlight = widget.highlightColor ?? const Color(0xFFF8FAFC);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, child) {
        final startValue = isRtl ? -_animation.value : _animation.value;
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [base, highlight, base],
              stops: const [0.1, 0.5, 0.9],
              begin: Alignment(startValue - 1.0, -0.3),
              end: Alignment(startValue + 1.0, 0.3),
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}
