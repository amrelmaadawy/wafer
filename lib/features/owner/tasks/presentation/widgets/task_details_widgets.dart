import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../domain/entities/task_entity.dart';

class TaskDatesCard extends StatelessWidget {
  final TaskDatesEntity dates;
  final VoidCallback? onEditPressed;

  const TaskDatesCard({super.key, required this.dates, this.onEditPressed});

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.calendar_month_rounded, color: Theme.of(context).primaryColor, size: 20),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  LocaleKeys.task_dates_title.tr(),
                  style: AppTextStyles.h4.copyWith(
                    fontWeight: FontWeight.w800,
                    color: context.appOnSurfaceColor,
                  ),
                ),
                if (onEditPressed != null) ...[
                  const Spacer(),
                  IconButton(
                    onPressed: onEditPressed,
                    icon: Icon(Icons.edit_outlined, color: Theme.of(context).primaryColor, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Divider(height: 1, color: context.appSecondaryTextColor.withValues(alpha: 0.1)),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                _buildDateRow(
                  context,
                  label: LocaleKeys.contractsStartDateLabel.tr(),
                  value: dates.startDate ?? '-',
                  icon: Icons.play_circle_outline_rounded,
                ),
                const SizedBox(height: AppSpacing.md),
                _buildDateRow(
                  context,
                  label: LocaleKeys.maintenanceDueDate.tr(),
                  value: dates.dueDate ?? '-',
                  icon: Icons.flag_circle_rounded,
                  isOverdue: dates.isOverdue,
                ),
                if (dates.completedAt != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  _buildDateRow(
                    context,
                    label: LocaleKeys.maintenanceCompletedDate.tr(),
                    value: dates.completedAt!,
                    icon: Icons.check_circle_outline_rounded,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRow(BuildContext context, {required String label, required String value, required IconData icon, bool isOverdue = false}) {
    final valueColor = isOverdue ? AppColors.error : context.appOnSurfaceColor;
    return Row(
      children: [
        Icon(icon, size: 20, color: context.appSecondaryTextColor.withValues(alpha: 0.5)),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: context.appSecondaryTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: isOverdue
              ? BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: AppRadius.circularSm,
                )
              : null,
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }
}

class TaskLinkedEntityCard extends StatelessWidget {
  final TaskEntity task;

  const TaskLinkedEntityCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    if (task.linkedEntity == null) return const SizedBox.shrink();

    String title = task.linkedEntity?.name ?? '';
    IconData icon = Icons.link_rounded;
    String? subtitle;

    if (task.property != null) {
      icon = Icons.domain_rounded;
      subtitle = task.property?.city;
    } else if (task.deed != null) {
      icon = Icons.description_rounded;
      subtitle = task.deed?.documentNumber;
    } else if (task.branch != null) {
      icon = Icons.business_rounded;
      subtitle = task.branch?.city;
    }

    return AppSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: AppRadius.circularMd,
            ),
            child: Icon(icon, color: Theme.of(context).primaryColor, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w800,
                    color: context.appOnSurfaceColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null && subtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: context.appSecondaryTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: context.appSecondaryTextColor.withValues(alpha: 0.5)),
        ],
      ),
    );
  }
}
