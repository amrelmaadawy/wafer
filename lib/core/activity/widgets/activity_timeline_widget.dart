import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../localization/locale_keys.dart';
import '../../presentation/widgets/custom_empty_widget.dart';
import '../../theme/app_fonts.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/color_utils.dart';
import '../../theme/theme_context.dart';
import '../entities/activity_log_entity.dart';
import 'activity_log_item_widget.dart';

class ActivityTimelineWidget extends StatelessWidget {
  final List<ActivityLogEntity> activities;
  final bool isScrollable;
  final bool showHeader;
  final EdgeInsetsGeometry padding;
  final String? emptyTitle;
  final String? emptySubtitle;

  const ActivityTimelineWidget({
    super.key,
    required this.activities,
    this.isScrollable = false,
    this.showHeader = true,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.emptyTitle,
    this.emptySubtitle,
  });

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return Padding(
        padding: padding,
        child: CustomEmptyWidget(
          icon: Icons.history_rounded,
          title: emptyTitle ?? LocaleKeys.activityEmpty.tr(),
          subtitle: emptySubtitle ?? LocaleKeys.activityEmptySubtitle.tr(),
        ),
      );
    }

    if (isScrollable) {
      return ListView.builder(
        padding: padding,
        itemCount: activities.length + (showHeader ? 1 : 0),
        itemBuilder: (context, index) {
          if (showHeader && index == 0) {
            return _buildHeader(context);
          }
          final logIndex = showHeader ? index - 1 : index;
          final isLast = logIndex == activities.length - 1;
          return ActivityLogItemWidget(
            log: activities[logIndex],
            isLast: isLast,
          );
        },
      );
    }

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showHeader) _buildHeader(context),
          ...activities.asMap().entries.map((entry) {
            final isLast = entry.key == activities.length - 1;
            return ActivityLogItemWidget(
              log: entry.value,
              isLast: isLast,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.history_rounded,
                size: 20,
                color: context.primaryColor,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                LocaleKeys.activityTitle.tr(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: AppFonts.bold,
                  color: context.appOnSurfaceColor,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: context.primaryColor.withA(0.12),
              borderRadius: AppRadius.circularSm,
            ),
            child: Text(
              LocaleKeys.activityCount.tr(
                args: [activities.length.toString()],
              ),
              style: TextStyle(
                fontSize: 12,
                fontWeight: AppFonts.semiBold,
                color: context.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
