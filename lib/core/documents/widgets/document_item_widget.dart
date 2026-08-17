import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../localization/locale_keys.dart';
import '../../theme/app_fonts.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_shadows.dart';
import '../../theme/app_spacing.dart';
import '../../theme/color_utils.dart';
import '../../theme/theme_context.dart';
import '../../utils/widgets/app_toast.dart';
import '../entities/document_item_entity.dart';
import 'document_type_badge.dart';

class DocumentItemWidget extends StatelessWidget {
  final DocumentItemEntity document;
  final VoidCallback? onTap;

  const DocumentItemWidget({
    super.key,
    required this.document,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.appSurfaceColor,
        borderRadius: AppRadius.circularLg,
        border: Border.all(
          color: context.appBorderColor,
          width: 1,
        ),
        boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.circularLg,
        child: InkWell(
          borderRadius: AppRadius.circularLg,
          onTap: onTap ?? () => _openDocument(context),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                _buildIcon(context),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              document.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: AppFonts.semiBold,
                                color: context.appOnSurfaceColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          DocumentTypeBadge(type: document.type),
                        ],
                      ),
                      if (document.description != null &&
                          document.description!.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          document.description!,
                          style: TextStyle(
                            fontSize: 12,
                            color: context.appSecondaryTextColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: AppSpacing.xs),
                      _buildMetaInfo(context),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Icon(
                  Icons.open_in_new_rounded,
                  size: 18,
                  color: context.primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    final (icon, color) = _getIconData(context);
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withA(0.12),
        borderRadius: AppRadius.circularMd,
      ),
      child: Center(
        child: Icon(
          icon,
          color: color,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildMetaInfo(BuildContext context) {
    final metaParts = <String>[];
    if (document.fileSize != null && document.fileSize!.isNotEmpty) {
      metaParts.add(document.fileSize!);
    }
    if (document.createdAt != null && document.createdAt!.isNotEmpty) {
      metaParts.add(document.createdAt!);
    }

    if (metaParts.isEmpty) {
      return Text(
        LocaleKeys.documentsOpenFile.tr(),
        style: TextStyle(
          fontSize: 11,
          color: context.primaryColor,
          fontWeight: AppFonts.medium,
        ),
      );
    }

    return Text(
      metaParts.join(' • '),
      style: TextStyle(
        fontSize: 11,
        color: context.appSecondaryTextColor,
        fontWeight: AppFonts.regular,
      ),
    );
  }

  (IconData, Color) _getIconData(BuildContext context) {
    switch (document.type) {
      case DocumentType.pdf:
        return (
          Icons.picture_as_pdf_outlined,
          Colors.red.shade700,
        );
      case DocumentType.image:
        return (
          Icons.image_outlined,
          context.primaryColor,
        );
      case DocumentType.other:
        return (
          Icons.insert_drive_file_outlined,
          Colors.blueGrey.shade600,
        );
    }
  }

  Future<void> _openDocument(BuildContext context) async {
    if (document.url.isEmpty) return;
    try {
      final uri = Uri.parse(document.url);
      final canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          AppToast.showError(context, LocaleKeys.documentsOpenError.tr());
        }
      }
    } catch (_) {
      if (context.mounted) {
        AppToast.showError(context, LocaleKeys.documentsOpenError.tr());
      }
    }
  }
}
