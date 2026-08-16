import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/core/theme/color_utils.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/custom_empty_widget.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../domain/entities/property_details_entity.dart';
import '../../../domain/entities/media_item_entity.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final doc = docs[index];
        final isPdf = doc.url.toLowerCase().endsWith('.pdf') ||
            doc.type.toLowerCase().contains('pdf');

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.circularXl,
            border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
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
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.1),
                borderRadius: AppRadius.circularLg,
              ),
              child: Icon(
                isPdf ? Icons.picture_as_pdf_outlined : Icons.description_outlined,
                color: context.primaryColor,
                size: 24,
              ),
            ),
            title: Text(
              doc.description ??
                  (doc.type.isNotEmpty ? doc.type : 'Document ${index + 1}'),
              style: const TextStyle(
                fontFamily: AppFonts.fontFamilyPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            subtitle: doc.createdAt != null
                ? Text(
                    doc.createdAt!,
                    style: TextStyle(
                      fontFamily: AppFonts.fontFamilyPrimary,
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  )
                : null,
            trailing: Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey.shade400,
            ),
          ),
        );
      },
    );
  }
}
