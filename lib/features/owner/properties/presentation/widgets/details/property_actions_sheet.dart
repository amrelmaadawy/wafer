import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/property_details_entity.dart';

class PropertyActionsSheet extends StatelessWidget {
  final PropertyDetailsEntity property;
  final VoidCallback onEdit;
  final VoidCallback onClone;
  final VoidCallback onMakeRepresentative;
  final VoidCallback onDelete;

  const PropertyActionsSheet({
    super.key,
    required this.property,
    required this.onEdit,
    required this.onClone,
    required this.onMakeRepresentative,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.topXxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: AppRadius.circularFull,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.edit_outlined, color: context.primaryColor),
            title: Text(
              LocaleKeys.propertyDetailsEdit.tr(),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            onTap: () {
              Navigator.pop(context);
              onEdit();
            },
          ),
          ListTile(
            leading: const Icon(Icons.copy_rounded, color: Color(0xFF10B981)),
            title: Text(
              LocaleKeys.propertyDetailsClone.tr(),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            onTap: () {
              Navigator.pop(context);
              onClone();
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_add_alt_outlined, color: Color(0xFFF59E0B)),
            title: Text(
              LocaleKeys.propertyDetailsRepresentative.tr(),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            onTap: () {
              Navigator.pop(context);
              onMakeRepresentative();
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
            title: Text(
              LocaleKeys.propertyDetailsDelete.tr(),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.error,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              onDelete();
            },
          ),
        ],
      ),
    );
  }
}
