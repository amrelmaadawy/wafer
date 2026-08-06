import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../localization/locale_keys.dart';
import '../../theme/app_radius.dart';

enum NotificationType { success, error, info }

class CustomNotification {
  CustomNotification._();

  static void showSuccess(
    BuildContext context,
    String message, {
    String? title,
  }) {
    _show(
      context: context,
      message: message,
      title: title ?? LocaleKeys.commonSuccess.tr(),
      type: NotificationType.success,
    );
  }

  static void showError(BuildContext context, String message, {String? title}) {
    _show(
      context: context,
      message: message,
      title: title ?? LocaleKeys.commonError.tr(),
      type: NotificationType.error,
    );
  }

  static void showInfo(BuildContext context, String message, {String? title}) {
    _show(
      context: context,
      message: message,
      title: title ?? LocaleKeys.commonInfo.tr(),
      type: NotificationType.info,
    );
  }

  static void _show({
    required BuildContext context,
    required String message,
    required String title,
    required NotificationType type,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _CustomNotificationWidget(
        title: title,
        message: message,
        type: type,
        onDismissed: () {
          if (overlayEntry.mounted) {
            overlayEntry.remove();
          }
        },
      ),
    );

    overlay.insert(overlayEntry);
  }
}

class _CustomNotificationWidget extends StatefulWidget {
  final String title;
  final String message;
  final NotificationType type;
  final VoidCallback onDismissed;

  const _CustomNotificationWidget({
    required this.title,
    required this.message,
    required this.type,
    required this.onDismissed,
  });

  @override
  State<_CustomNotificationWidget> createState() => _CustomNotificationWidgetState();
}

class _CustomNotificationWidgetState extends State<_CustomNotificationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        _controller.reverse().then((_) {
          if (mounted) {
            widget.onDismissed();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    IconData iconData;

    switch (widget.type) {
      case NotificationType.success:
        backgroundColor = const Color(0xFF10B981);
        iconData = Icons.check_circle_outline;
        break;
      case NotificationType.error:
        backgroundColor = const Color(0xFFEF4444);
        iconData = Icons.error_outline;
        break;
      case NotificationType.info:
        backgroundColor = const Color(0xFF3B82F6);
        iconData = Icons.info_outline;
        break;
    }

    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: SafeArea(
        child: Material(
          color: Colors.transparent,
          child: SlideTransition(
            position: _offsetAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: AppRadius.circularLg,
                  boxShadow: [
                    BoxShadow(
                      color: backgroundColor.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(iconData, color: Colors.white, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.title.isNotEmpty)
                            Text(
                              widget.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          if (widget.message.isNotEmpty) ...[
                            if (widget.title.isNotEmpty) const SizedBox(height: 4),
                            Text(
                              widget.message,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 20),
                      onPressed: () {
                        _controller.reverse().then((_) {
                          if (mounted) {
                            widget.onDismissed();
                          }
                        });
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
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
