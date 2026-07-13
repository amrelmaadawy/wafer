import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../localization/locale_keys.dart';
import 'app_toast_widget.dart';

enum AppToastType { success, error, info }

class AppToastColors {
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
}

class AppToast {
  AppToast._();

  static void showSuccess(BuildContext context, String message, {String? title}) {
    _show(context: context, message: message, title: title ?? LocaleKeys.commonSuccess.tr(), type: AppToastType.success);
  }

  static void showError(BuildContext context, String message, {String? title}) {
    _show(context: context, message: message, title: title ?? LocaleKeys.commonError.tr(), type: AppToastType.error);
  }

  static void showInfo(BuildContext context, String message, {String? title}) {
    _show(context: context, message: message, title: title ?? LocaleKeys.commonInfo.tr(), type: AppToastType.info);
  }

  static void _show({
    required BuildContext context,
    required String message,
    required String title,
    required AppToastType type,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => AppToastWidget(
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
