import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../localization/locale_keys.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_fonts.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/color_utils.dart';
import '../../theme/theme_context.dart';
import '../entities/activity_log_entity.dart';

class ActivityLogItemWidget extends StatelessWidget {
  final ActivityLogEntity log;
  final bool isLast;

  const ActivityLogItemWidget({
    super.key,
    required this.log,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _getVisuals(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTimelineNode(icon, color, context),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: context.appSurfaceColor,
                  borderRadius: AppRadius.circularMd,
                  border: Border.all(
                    color: context.appBorderColor,
                    width: 0.8,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    if (log.notes != null && log.notes!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        log.notes!,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: AppFonts.medium,
                          color: context.appOnSurfaceColor,
                          height: 1.4,
                        ),
                      ),
                    ],
                    if (_hasStatusOrUser) ...[
                      const SizedBox(height: AppSpacing.xs),
                      _buildFooter(context),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool get _hasStatusOrUser =>
      (log.newStatus != null && log.newStatus!.isNotEmpty) ||
      (log.performedByName != null && log.performedByName!.isNotEmpty);

  Widget _buildTimelineNode(IconData icon, Color color, BuildContext context) {
    return SizedBox(
      width: 36,
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withA(0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withA(0.3),
                width: 1.2,
              ),
            ),
            child: Center(
              child: Icon(icon, size: 16, color: color),
            ),
          ),
          if (!isLast)
            Expanded(
              child: Container(
                width: 1.5,
                color: context.appBorderColor,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            log.actionLabel ?? _getActionLabel(log.type),
            style: TextStyle(
              fontSize: 13,
              fontWeight: AppFonts.bold,
              color: context.appOnSurfaceColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (log.createdAt != null && log.createdAt!.isNotEmpty)
          Text(
            log.createdAt!,
            style: TextStyle(
              fontSize: 11,
              color: context.appSecondaryTextColor,
              fontWeight: AppFonts.regular,
            ),
          ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xxs,
      children: [
        if (log.newStatus != null && log.newStatus!.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: context.primaryColor.withA(0.08),
              borderRadius: AppRadius.circularSm,
            ),
            child: Text(
              log.newStatusLabel ??
                  LocaleKeys.activityStatusChanged.tr(
                    args: [log.newStatus!],
                  ),
              style: TextStyle(
                fontSize: 11,
                color: context.primaryColor,
                fontWeight: AppFonts.medium,
              ),
            ),
          ),
        if (log.performedByName != null && log.performedByName!.isNotEmpty)
          Text(
            LocaleKeys.activityByUser.tr(
              args: [log.performedByName!],
            ),
            style: TextStyle(
              fontSize: 11,
              color: context.appSecondaryTextColor,
              fontWeight: AppFonts.regular,
            ),
          ),
      ],
    );
  }

  String _getActionLabel(ActivityActionType type) {
    switch (type) {
      case ActivityActionType.created:
        return LocaleKeys.activityActionCreated.tr();
      case ActivityActionType.approved:
        return LocaleKeys.activityActionApproved.tr();
      case ActivityActionType.rejected:
        return LocaleKeys.activityActionRejected.tr();
      case ActivityActionType.assigned:
        return LocaleKeys.activityActionAssigned.tr();
      case ActivityActionType.updated:
        return LocaleKeys.activityActionUpdated.tr();
      case ActivityActionType.completed:
        return LocaleKeys.activityActionCompleted.tr();
      case ActivityActionType.cancelled:
        return LocaleKeys.activityActionCancelled.tr();
      case ActivityActionType.other:
        return log.action ?? LocaleKeys.activityTitle.tr();
    }
  }

  (IconData, Color) _getVisuals(BuildContext context) {
    switch (log.type) {
      case ActivityActionType.created:
        return (Icons.add_circle_outline_rounded, AppColors.info);
      case ActivityActionType.approved:
        return (Icons.check_circle_outline_rounded, AppColors.success);
      case ActivityActionType.rejected:
        return (Icons.cancel_outlined, AppColors.error);
      case ActivityActionType.assigned:
        return (Icons.assignment_ind_outlined, AppColors.warning);
      case ActivityActionType.updated:
        return (Icons.edit_note_rounded, context.primaryColor);
      case ActivityActionType.completed:
        return (Icons.verified_outlined, AppColors.success);
      case ActivityActionType.cancelled:
        return (Icons.block_rounded, AppColors.error);
      case ActivityActionType.other:
        return (Icons.history_rounded, Colors.blueGrey);
    }
  }
}
