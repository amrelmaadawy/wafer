import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../domain/entities/technician_performance_summary_entity.dart';

class TechnicianPerformanceSummaryHeader extends StatelessWidget {
  final TechnicianPerformanceSummaryEntity summary;

  const TechnicianPerformanceSummaryHeader({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.primaryColor, context.primaryColor.withAlpha(204)],
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
                  LocaleKeys.technicianPerformanceTotalTechnicians.tr(),
                  summary.totalTechnicians.toString(),
                ),
                const SizedBox(height: 16),
                Container(height: 1, color: Colors.white.withAlpha(30)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSubStat(
                      LocaleKeys.technicianPerformanceTotalPending.tr(),
                      summary.totalPending.toString(),
                      Icons.pending_actions_rounded,
                      Colors.orangeAccent,
                    ),
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.white.withAlpha(30),
                    ),
                    _buildSubStat(
                      LocaleKeys.technicianPerformanceTotalCompleted.tr(),
                      summary.totalCompleted.toString(),
                      Icons.task_alt_rounded,
                      Colors.greenAccent,
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

  Widget _buildMainStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white.withAlpha(200),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSubStat(
    String label,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Column(
      children: [
        Icon(icon, size: 22, color: iconColor.withAlpha(200)),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.white.withAlpha(180),
          ),
        ),
      ],
    );
  }
}
