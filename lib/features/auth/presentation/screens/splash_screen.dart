import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/color_utils.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final startTime = DateTime.now();

    return BlocProvider(
      create: (context) => sl<AuthCubit>()..checkAuthStatus(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) async {
          // Guarantee a minimum splash duration (2.5s) so the full animation sequence plays smoothly
          final elapsed = DateTime.now().difference(startTime);
          const minDuration = Duration(milliseconds: 2500);
          if (elapsed < minDuration) {
            await Future.delayed(minDuration - elapsed);
          }

          if (!context.mounted) return;

          if (state is Authenticated) {
            if (state.user.accountType == 'owner') {
              context.go(Routes.ownerDashboard);
            } else if (state.user.accountType == 'system' ||
                state.user.accountType == 'company') {
              context.go(Routes.companyDashboard);
            } else if (state.user.accountType == 'tenant') {
              context.go(Routes.tenantDashboard);
            } else {
              context.go(Routes.ownerDashboard); // Fallback
            }
          } else if (state is Unauthenticated) {
            context.go(Routes.login);
          }
        },
        child: const _SplashBody(),
      ),
    );
  }
}

class _SplashBody extends StatefulWidget {
  const _SplashBody();

  @override
  State<_SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<_SplashBody> with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _bgRotateController;
  late final AnimationController _dotsController;

  late final Animation<double> _logoScale;
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _taglineOpacity;
  late final Animation<Offset> _taglineSlide;

  @override
  void initState() {
    super.initState();
    
    // 1. Entrance Animation (Spring effect and staggered fading)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Spring scale for the logo (0.0 to 1.0)
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.1, 0.6, curve: Curves.elasticOut),
      ),
    );

    // Slide and fade for the brand text (starts slightly after logo)
    _textSlide = Tween<Offset>(begin: const Offset(0.0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic),
      ),
    );
    
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeIn),
      ),
    );

    // Slide and fade for the tagline (starts slightly after the title)
    _taglineSlide = Tween<Offset>(begin: const Offset(0.0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    // Haptic feedback when the logo "hits" the peak of the spring
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) HapticFeedback.lightImpact();
    });

    // 2. Background continuous rotation
    _bgRotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();

    // 3. Staggered Dots Animation
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    // Start entrance animation
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _bgRotateController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Premium Minimalist Palette
    // Light mode: Clean white background, Dark Blue text/icons
    // Dark mode: Dark background, White text/icons
    final backgroundColor = isDark ? AppColors.backgroundDark : AppColors.surfaceLight;
    final mainElementsColor = isDark ? Colors.white : context.primaryColor;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          alignment: Alignment.center,
          children: [
            // 1. Subtle Background Watermark
            AnimatedBuilder(
              animation: _bgRotateController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _bgRotateController.value * 2 * math.pi,
                  child: Opacity(
                    opacity: isDark ? 0.08 : 0.12, // Increased visibility based on feedback
                    child: Icon(
                      Icons.maps_home_work_rounded, // More professional ERP icon
                      size: 450,
                      color: mainElementsColor,
                    ),
                  ),
                );
              },
            ),

            // 2. Main Content
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 4),
                  
                  // Animated Logo & Text
                  AnimatedBuilder(
                    animation: _entranceController,
                    builder: (context, child) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Spring Logo (Clean, no box)
                          Transform.scale(
                            scale: _logoScale.value,
                            child: Icon(
                              Icons.maps_home_work_rounded,
                              size: 96,
                              color: mainElementsColor,
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Slide + Fade Text
                          Opacity(
                            opacity: _textOpacity.value,
                            child: SlideTransition(
                              position: _textSlide,
                              child: Text(
                                LocaleKeys.auth_brand_name.tr(),
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                  color: mainElementsColor,
                                  letterSpacing: 1.2,
                                  height: 1.2,
                                ),
                              ),
                            ),
                          ),
                          
                          // Tagline
                          Opacity(
                            opacity: _taglineOpacity.value,
                            child: SlideTransition(
                              position: _taglineSlide,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  "splashTagline".tr(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: mainElementsColor.withValues(alpha: 0.7),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  
                  const Spacer(flex: 3),
                  
                  // 3. Staggered Wave Loading Dots
                  Padding(
                    padding: const EdgeInsets.only(bottom: 56.0),
                    child: _StaggeredDotsLoader(
                      controller: _dotsController,
                      color: mainElementsColor, // Matches the theme perfectly
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StaggeredDotsLoader extends StatelessWidget {
  final AnimationController controller;
  final Color color;

  const _StaggeredDotsLoader({
    required this.controller,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            // Create a staggered phase for each dot
            final t = (controller.value * 2 * math.pi) + (index * math.pi / 2.5);
            // Sine wave for smooth oscillating scale and opacity
            final value = (math.sin(t) + 1) / 2; // Normalize to 0..1
            
            final size = 6.0 + (value * 4.0); // Size pulses between 6 and 10
            final opacity = 0.3 + (value * 0.7); // Opacity pulses between 0.3 and 1.0

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color.withValues(alpha: opacity),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
