import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/color_utils.dart';
import '../widgets/building_blueprint_painter.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SplashBody();
  }
}

class _SplashBody extends StatefulWidget {
  const _SplashBody();

  @override
  State<_SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<_SplashBody> with TickerProviderStateMixin {
  late final AnimationController _masterController;

  // Phase 1: 0–150ms — Background fade in
  late final Animation<double> _bgOpacity;

  // Phase 2: 150–500ms — Draw architectural lines
  late final Animation<double> _drawProgress;

  // Phase 3: 500–750ms — Fill with theme color
  late final Animation<double> _fillOpacity;

  // Phase 3b: 600–850ms — Glow blooms behind the icon
  late final Animation<double> _glowOpacity;

  // Phase 4: 650–900ms — App name & tagline slide up
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;

  // Phase 4b: 700–950ms — Subtle divider line grows
  late final Animation<double> _dividerWidth;

  // Phase 5: 900–1050ms — Bottom caption fades in
  late final Animation<double> _captionOpacity;

  @override
  void initState() {
    super.initState();

    // Total intro: 2200ms — slow and cinematic so the user can appreciate every phase
    _masterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    final c = _masterController;

    _bgOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: c, curve: const Interval(0.0, 0.14, curve: Curves.easeIn)),
    );

    _drawProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: c, curve: const Interval(0.14, 0.52, curve: Curves.easeInOutCubic)),
    );

    _fillOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: c, curve: const Interval(0.50, 0.72, curve: Curves.easeIn)),
    );

    _glowOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: c, curve: const Interval(0.58, 0.80, curve: Curves.easeOut)),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: c, curve: const Interval(0.64, 0.90, curve: Curves.easeOut)),
    );

    _textSlide = Tween<Offset>(begin: const Offset(0.0, 0.25), end: Offset.zero).animate(
      CurvedAnimation(parent: c, curve: const Interval(0.64, 0.92, curve: Curves.easeOutCubic)),
    );

    _dividerWidth = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: c, curve: const Interval(0.70, 0.90, curve: Curves.easeOut)),
    );

    _captionOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: c, curve: const Interval(0.85, 1.0, curve: Curves.easeOut)),
    );

    _masterController.forward();
  }

  @override
  void dispose() {
    _masterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = context.primaryColor;
    final backgroundColor = isDark ? AppColors.backgroundDark : AppColors.surfaceLight;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: AnimatedBuilder(
          animation: _masterController,
          builder: (context, _) {
            return Opacity(
              opacity: _bgOpacity.value,
              child: _buildBody(context, primaryColor, isDark),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, Color primaryColor, bool isDark) {
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Stack(
      children: [
        // ── Subtle radial glow on background ──────────────────────────────
        if (_glowOpacity.value > 0)
          Positioned.fill(
            child: Opacity(
              opacity: _glowOpacity.value * 0.12,
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.25),
                    radius: 1.2,
                    colors: [
                      primaryColor.withValues(alpha: 0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

        // ── Main centered content ──────────────────────────────────────────
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Building icon — wider than tall for a proper skyline feel
                SizedBox(
                  width: 240,
                  height: 160,
                  child: CustomPaint(
                    painter: BuildingBlueprintPainter(
                      drawProgress: _drawProgress.value,
                      fillOpacity: _fillOpacity.value,
                      glowOpacity: _glowOpacity.value,
                      themeColor: primaryColor,
                    ),
                  ),
                ),

                const SizedBox(height: 36),

                // Animated text block
                SlideTransition(
                  position: _textSlide,
                  child: Opacity(
                    opacity: _textOpacity.value,
                    child: Column(
                      children: [
                        // App name
                        Text(
                          LocaleKeys.authBrandName.tr(),
                          style: TextStyle(
                            fontFamily: AppFonts.fontFamilyEn,
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            color: primaryColor,
                            letterSpacing: 2.5,
                            height: 1.1,
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Animated divider
                        LayoutBuilder(builder: (ctx, constraints) {
                          return Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: constraints.maxWidth * 0.45 * _dividerWidth.value,
                              height: 1.5,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    primaryColor.withValues(alpha: 0.0),
                                    primaryColor.withValues(alpha: 0.8),
                                    primaryColor.withValues(alpha: 0.0),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        }),

                        const SizedBox(height: 14),

                        // Tagline
                        Text(
                          LocaleKeys.splashTagline.tr(),
                          style: TextStyle(
                            fontFamily: AppFonts.fontFamilyPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: textSecondary,
                            letterSpacing: 0.3,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Bottom caption ─────────────────────────────────────────────────
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Opacity(
            opacity: _captionOpacity.value,
            child: Text(
              LocaleKeys.authCopyrights.tr(),
              style: TextStyle(
                fontFamily: AppFonts.fontFamilyPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: textSecondary.withValues(alpha: 0.6),
                letterSpacing: 0.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
