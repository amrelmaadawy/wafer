import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theme/app_colors.dart';
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

class _SplashBodyState extends State<_SplashBody>
    with TickerProviderStateMixin {
  late final AnimationController _bgController;
  late final AnimationController _buildController;
  late final AnimationController _textController;

  @override
  void initState() {
    super.initState();
    // Background Orbs
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    // Skyline Building
    _buildController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Text Reveal
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Sequence
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _buildController.forward();
      }
    });

    _buildController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        _textController.forward();
      }
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _buildController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Deep Slate/Navy
      body: Stack(
        children: [
          // 1. Animated Glowing Orbs
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned(
                    top: -100 + (80 * _bgController.value),
                    left: -100 - (50 * _bgController.value),
                    child: _buildOrb(AppColors.primary, 350),
                  ),
                  Positioned(
                    bottom: -150 - (60 * _bgController.value),
                    right: -100 + (80 * _bgController.value),
                    child: _buildOrb(AppColors.secondary, 450),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.4,
                    right: -50 - (40 * _bgController.value),
                    child: _buildOrb(AppColors.primaryLight, 250),
                  ),
                ],
              );
            },
          ),

          // 2. Glassmorphism Blur Layer
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
              child: Container(
                color: Colors.black.withValues(alpha: 0.15),
              ),
            ),
          ),

          // 3. Main Content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated Skyline Logo
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildPillar(0.0, 0.4, 45, AppColors.secondary),
                      const SizedBox(width: 10),
                      _buildPillar(0.15, 0.6, 85, Colors.white),
                      const SizedBox(width: 10),
                      _buildPillar(0.3, 0.8, 100, AppColors.primaryLight),
                      const SizedBox(width: 10),
                      _buildPillar(0.45, 1.0, 60, Colors.white70),
                    ],
                  ),
                ),
                const SizedBox(height: 36),

                // Animated Text Reveal
                AnimatedBuilder(
                  animation: _textController,
                  builder: (context, child) {
                    final opacity = CurvedAnimation(
                      parent: _textController,
                      curve: Curves.easeIn,
                    ).value;
                    final slide = Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _textController,
                      curve: Curves.easeOutCubic,
                    )).value;

                    return Opacity(
                      opacity: opacity,
                      child: SlideTransition(
                        position: AlwaysStoppedAnimation(slide),
                        child: const Text(
                          'وافر',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 2.5,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 15,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // 4. Sleek Footer Loading Bar
          Positioned(
            bottom: 56,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _textController,
              builder: (context, child) {
                return Opacity(
                  opacity: _textController.value,
                  child: child,
                );
              },
              child: Column(
                children: [
                  SizedBox(
                    width: 80,
                    height: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: const LinearProgressIndicator(
                        backgroundColor: Colors.white12,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.secondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'WAFER REAL ESTATE ERP',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withValues(alpha: 0.4),
                      letterSpacing: 3.0,
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

  Widget _buildOrb(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.45),
      ),
    );
  }

  Widget _buildPillar(double start, double end, double height, Color color) {
    return AnimatedBuilder(
      animation: _buildController,
      builder: (context, child) {
        final animation = CurvedAnimation(
          parent: _buildController,
          curve: Interval(start, end, curve: Curves.elasticOut),
        );
        final opacityAnim = CurvedAnimation(
          parent: _buildController,
          curve: Interval(start, start + 0.2, curve: Curves.easeIn),
        );

        return Transform.translate(
          offset: Offset(0, height * (1 - animation.value)),
          child: Opacity(
            opacity: opacityAnim.value.clamp(0.0, 1.0),
            child: Container(
              width: 14,
              height: height,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4 * opacityAnim.value),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
