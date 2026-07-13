import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import 'app_toast.dart';

class AppToastWidget extends StatefulWidget {
  final String title;
  final String message;
  final AppToastType type;
  final VoidCallback onDismissed;

  const AppToastWidget({
    super.key,
    required this.title,
    required this.message,
    required this.type,
    required this.onDismissed,
  });

  @override
  State<AppToastWidget> createState() => _AppToastWidgetState();
}

class _AppToastWidgetState extends State<AppToastWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    _timer = Timer(const Duration(milliseconds: 3500), () async {
      if (mounted) {
        await _controller.reverse();
        widget.onDismissed();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Color get _accentColor => widget.type == AppToastType.success
      ? AppToastColors.success
      : (widget.type == AppToastType.error ? AppToastColors.error : AppToastColors.info);

  IconData get _icon => widget.type == AppToastType.success
      ? Icons.check_circle_rounded
      : (widget.type == AppToastType.error ? Icons.error_rounded : Icons.info_rounded);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 14,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: SlideTransition(
          position: _offsetAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: AppRadius.circularLg,
                  border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.8)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 24, offset: const Offset(0, 8)),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(color: _accentColor.withValues(alpha: 0.12), shape: BoxShape.circle),
                      child: Icon(_icon, color: _accentColor, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(widget.title, style: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text(widget.message, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 12.5, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await _controller.reverse();
                        widget.onDismissed();
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(Icons.close_rounded, size: 18, color: AppColors.textSecondaryLight.withValues(alpha: 0.6)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
