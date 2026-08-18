import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/custom_empty_widget.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/theme/theme_context.dart';
import '../../../domain/entities/media_item_entity.dart';
import '../../../domain/entities/property_details_entity.dart';

class PropertyDocumentsTab extends StatelessWidget {
  final PropertyDetailsEntity property;

  const PropertyDocumentsTab({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final docs = <MediaItemEntity>[...property.documents];

    if (property.deedAttachment != null &&
        property.deedAttachment!.isNotEmpty &&
        docs.every((d) => d.url != property.deedAttachment)) {
      docs.insert(
        0,
        MediaItemEntity(
          id: property.deedId ?? 0,
          path: property.deedAttachment!,
          url: property.deedAttachment!,
          type: property.documentType ?? 'deed',
          description: property.deedNumber != null
              ? '${property.documentType ?? 'Deed'}: ${property.deedNumber}'
              : null,
          createdAt: property.deedDate,
        ),
      );
    }

    if (docs.isEmpty) {
      return CustomEmptyWidget(
        icon: Icons.folder_open_outlined,
        title: LocaleKeys.propertyDetailsNoDocuments.tr(),
        subtitle: LocaleKeys.propertyDetailsNoDocumentsSubtitle.tr(),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final doc = docs[index];
        final isPdf = doc.url.toLowerCase().endsWith('.pdf') ||
            doc.type.toLowerCase().contains('pdf');

        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          decoration: BoxDecoration(
            color: context.appSurfaceColor,
            borderRadius: AppRadius.circularXl,
            border: Border.all(color: context.appBorderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.1),
                borderRadius: AppRadius.circularLg,
              ),
              child: Icon(
                isPdf
                    ? Icons.picture_as_pdf_outlined
                    : Icons.description_outlined,
                color: context.primaryColor,
                size: 24,
              ),
            ),
            title: Text(
              doc.description ??
                  (doc.type.isNotEmpty ? doc.type : 'Document ${index + 1}'),
              style: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: context.appOnSurfaceColor,
              ),
            ),
            subtitle: doc.createdAt != null
                ? Text(
                    doc.createdAt!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: context.appSecondaryTextColor,
                    ),
                  )
                : null,
            trailing: Icon(
              Icons.chevron_right_rounded,
              color: context.appSecondaryTextColor,
            ),
          ),
        );
      },
    );
  }
}
