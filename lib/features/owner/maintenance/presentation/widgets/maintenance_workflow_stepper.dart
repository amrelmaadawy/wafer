import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../domain/entities/maintenance_item_entity.dart';
import '../../domain/entities/maintenance_status_extension.dart';

class MaintenanceWorkflowStepper extends StatelessWidget {
  final MaintenanceItemEntity item;

  const MaintenanceWorkflowStepper({super.key, required this.item});

  static const List<String> _stepLocaleKeys = [
    LocaleKeys.maintenanceWorkflowNew,
    LocaleKeys.maintenanceWorkflowApproved,
    LocaleKeys.maintenanceWorkflowAssigned,
    LocaleKeys.maintenanceWorkflowInProgress,
    LocaleKeys.maintenanceWorkflowExecuted,
    LocaleKeys.maintenanceWorkflowClosed,
  ];

  @override
  Widget build(BuildContext context) {
    if (item.isTerminalState) {
      return _buildTerminalBanner(context);
    }

    final currentIndex = item.workflowStepIndex;
    final primary = context.primaryColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularXxl,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.maintenanceTimelineSection.tr(),
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (item.statusLabel != null && item.statusLabel!.isNotEmpty)
                Text(
                  item.statusLabel!,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: List.generate(_stepLocaleKeys.length * 2 - 1, (index) {
                  if (index.isOdd) {
                    final stepBefore = index ~/ 2;
                    final isLinePassed = stepBefore < currentIndex;
                    return Expanded(
                      child: Container(
                        height: 2.5,
                        color: isLinePassed
                            ? AppColors.success
                            : AppColors.borderLight,
                      ),
                    );
                  }
                  final stepIndex = index ~/ 2;
                  return _buildStepNode(
                    context,
                    stepIndex: stepIndex,
                    currentIndex: currentIndex,
                    primary: primary,
                  );
                }),
              );
            },
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_stepLocaleKeys.length, (index) {
              final isCurrent = index == currentIndex;
              final isPassed = index < currentIndex;
              return Expanded(
                child: Text(
                  _stepLocaleKeys[index].tr(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelSmall.copyWith(
                    fontSize: 10,
                    color: isCurrent
                        ? primary
                        : (isPassed
                            ? AppColors.textPrimaryLight
                            : AppColors.textSecondaryLight),
                    fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w500,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStepNode(
    BuildContext context, {
    required int stepIndex,
    required int currentIndex,
    required Color primary,
  }) {
    final isPassed = stepIndex < currentIndex;
    final isCurrent = stepIndex == currentIndex;

    Color bgColor;
    Widget child;

    if (isPassed) {
      bgColor = AppColors.success;
      child = const Icon(Icons.check_rounded, color: Colors.white, size: 12);
    } else if (isCurrent) {
      bgColor = primary;
      child = Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      );
    } else {
      bgColor = AppColors.surfaceLight;
      child = Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          color: AppColors.borderLight,
          shape: BoxShape.circle,
        ),
      );
    }

    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: isPassed
              ? AppColors.success
              : (isCurrent ? primary : AppColors.borderLight),
          width: 1.5,
        ),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: primary.withValues(alpha: 0.35),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              ]
            : null,
      ),
      child: Center(child: child),
    );
  }

  Widget _buildTerminalBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: AppRadius.circularXxl,
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.cancel_outlined, color: AppColors.error, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item.statusLabel ?? item.status ?? '',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
