import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
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
          // Guarantee a minimum splash duration (1.8s) so animation plays smoothly
          final elapsed = DateTime.now().difference(startTime);
          const minDuration = Duration(milliseconds: 1800);
          if (elapsed < minDuration) {
            await Future.delayed(minDuration - elapsed);
          }

          if (!context.mounted) return;

          if (state is Authenticated) {
            context.go(Routes.ownerDashboard);
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

class _SplashBodyState extends State<_SplashBody>
    with TickerProviderStateMixin {
  late final AnimationController _mainController;
  late final AnimationController _pulseController;
  late final Animation<double> _fadeIn;
  late final Animation<double> _scaleUp;
  late final Animation<double> _pulseGlow;

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _fadeIn = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.75, curve: Curves.easeOut),
    );

    _scaleUp = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
      ),
    );

    _pulseGlow = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.primaryColor;
    final primaryLight = context.primaryLight;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          // 1. Soft Light Modern Background & Subtle Ambient Gradients
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFFFFF),
                    Color(0xFFF8FAFC),
                    Color(0xFFF1F5F9),
                  ],
                ),
              ),
            ),
          ),

          // 2. Soft Ambient Primary Glow in Center
          Center(
            child: AnimatedBuilder(
              animation: _pulseGlow,
              builder: (context, child) {
                return Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        primary.withValues(alpha: 0.12 * _pulseGlow.value),
                        primary.withValues(alpha: 0.03 * _pulseGlow.value),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                );
              },
            ),
          ),

          // 3. Main Center Content
          Center(
            child: FadeTransition(
              opacity: _fadeIn,
              child: ScaleTransition(
                scale: _scaleUp,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Premium Elevated Logo Card
                    AnimatedBuilder(
                      animation: _pulseGlow,
                      builder: (context, child) {
                        return Container(
                          width: 112,
                          height: 112,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: primary.withValues(
                                alpha: 0.12 + (0.08 * _pulseGlow.value),
                              ),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: context.primaryShadow.withValues(
                                  alpha: 0.15 + (0.1 * _pulseGlow.value),
                                ),
                                blurRadius: 28,
                                offset: const Offset(0, 10),
                                spreadRadius: 2,
                              ),
                              BoxShadow(
                                color: primary.withValues(
                                  alpha: 0.08 * _pulseGlow.value,
                                ),
                                blurRadius: 40,
                                spreadRadius: 6,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                gradient: LinearGradient(
                                  colors: [
                                    primary,
                                    primaryLight,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: primary.withValues(alpha: 0.35),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.apartment_rounded,
                                color: Colors.white,
                                size: 38,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 28),

                    // App Name (وافر)
                    Text(
                      'وافر',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Tagline Pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: primary.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Text(
                        'نظام إدارة العقارات والحلول المالية',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: primary.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4. Sleek Footer Loading Bar & Text
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeIn,
              child: Column(
                children: [
                  // Elegant Progress Bar
                  SizedBox(
                    width: 130,
                    height: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        backgroundColor: const Color(0xFFE2E8F0),
                        valueColor: AlwaysStoppedAnimation<Color>(primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Footer Badge
                  const Text(
                    'WAFER REAL ESTATE ERP',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF94A3B8),
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
