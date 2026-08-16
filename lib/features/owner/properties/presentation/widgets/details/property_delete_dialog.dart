import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/app_confirm_dialog.dart';

class PropertyDeleteDialog {
  static Future<void> show(
    BuildContext context, {
    required VoidCallback onConfirm,
  }) async {
    final confirmed = await AppConfirmDialog.show(
      context: context,
      titleKey: LocaleKeys.propertyDetailsDeleteConfirmTitle,
      messageKey: LocaleKeys.propertyDetailsDeleteConfirmBody,
      impactKey: LocaleKeys.commonActionCannotBeUndone,
      isDangerous: true,
    );
    if (confirmed == true) {
      onConfirm();
    }
  }
}
