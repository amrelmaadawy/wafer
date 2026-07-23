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
      padding: const EdgeInsets.only(top: 12, bottom: 32, left: 20, right: 20),
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: AppRadius.topXxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: const BoxDecoration(
                color: AppColors.borderLight,
                borderRadius: AppRadius.circularFull,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Header with Property info
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.apartment_rounded, color: context.primaryColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimaryLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      property.code,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Grouped standard actions
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLight),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildActionItem(
                  context: context,
                  title: LocaleKeys.propertyDetailsEdit.tr(),
                  icon: Icons.edit_rounded,
                  color: context.primaryColor,
                  onTap: onEdit,
                  isFirst: true,
                ),
                const Divider(height: 1, color: AppColors.borderLight),
                _buildActionItem(
                  context: context,
                  title: LocaleKeys.propertyDetailsClone.tr(),
                  icon: Icons.content_copy_rounded,
                  color: AppColors.success,
                  onTap: onClone,
                ),
                const Divider(height: 1, color: AppColors.borderLight),
                _buildActionItem(
                  context: context,
                  title: LocaleKeys.propertyDetailsRepresentative.tr(),
                  icon: Icons.person_add_rounded,
                  color: AppColors.warning,
                  onTap: onMakeRepresentative,
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Destructive action separate
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.error.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _buildActionItem(
              context: context,
              title: LocaleKeys.propertyDetailsDelete.tr(),
              icon: Icons.delete_rounded,
              color: AppColors.error,
              onTap: onDelete,
              isDestructive: true,
              isFirst: true,
              isLast: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isDestructive = false,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(isFirst ? 16 : 0),
          bottom: Radius.circular(isLast ? 16 : 0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDestructive ? AppColors.error.withValues(alpha: 0.1) : color.withValues(alpha: 0.1),
                  borderRadius: AppRadius.circularMd,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: isDestructive ? AppColors.error : AppColors.textPrimaryLight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
