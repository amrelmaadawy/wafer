import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../localization/locale_keys.dart';
import '../../theme/app_fonts.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/color_utils.dart';
import '../entities/document_item_entity.dart';

class DocumentTypeBadge extends StatelessWidget {
  final DocumentType type;

  const DocumentTypeBadge({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final (label, color) = _getBadgeConfig(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withA(0.12),
        borderRadius: AppRadius.circularSm,
        border: Border.all(
          color: color.withA(0.3),
          width: 0.8,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: AppFonts.semiBold,
          color: color,
        ),
      ),
    );
  }

  (String, Color) _getBadgeConfig(BuildContext context) {
    switch (type) {
      case DocumentType.pdf:
        return (
          LocaleKeys.documentTypePdf.tr(),
          Colors.red.shade700,
        );
      case DocumentType.image:
        return (
          LocaleKeys.documentTypeImage.tr(),
          context.primaryColor,
        );
      case DocumentType.other:
        return (
          LocaleKeys.documentTypeFile.tr(),
          Colors.blueGrey.shade600,
        );
    }
  }
}
