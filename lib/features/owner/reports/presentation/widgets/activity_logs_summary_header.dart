import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../domain/entities/activity_logs_summary_entity.dart';

class ActivityLogsSummaryHeader extends StatelessWidget {
  final ActivityLogsSummaryEntity summary;

  const ActivityLogsSummaryHeader({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.primaryColor,
            context.primaryColor.withAlpha(204),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.circularLg,
        boxShadow: [
          BoxShadow(
            color: context.primaryColor.withAlpha(51),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -20,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white.withAlpha(15),
            ),
          ),
          Positioned(
            left: -20,
            bottom: -30,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white.withAlpha(15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMainStat(
                  context,
                  LocaleKeys.activityLogsTotalLogs.tr(),
                  summary.totalLogs.toString(),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 1,
                  color: Colors.white.withAlpha(30),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSubStat(
                      context,
                      LocaleKeys.activityLogsCreates.tr(),
                      summary.creates.toString(),
                      Icons.add_circle_outline_rounded,
                      Colors.greenAccent,
                    ),
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.white.withAlpha(30),
                    ),
                    _buildSubStat(
                      context,
                      LocaleKeys.activityLogsUpdates.tr(),
                      summary.updates.toString(),
                      Icons.edit_outlined,
                      Colors.orangeAccent,
                    ),
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.white.withAlpha(30),
                    ),
                    _buildSubStat(
                      context,
                      LocaleKeys.activityLogsDeletes.tr(),
                      summary.deletes.toString(),
                      Icons.delete_outline_rounded,
                      Colors.redAccent,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainStat(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withAlpha(204),
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildSubStat(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 6),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withAlpha(204),
                  fontSize: 10,
                ),
          ),
        ],
      ),
    );
  }
}
