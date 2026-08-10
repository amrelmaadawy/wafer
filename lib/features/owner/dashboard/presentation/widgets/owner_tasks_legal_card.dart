import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../domain/entities/owner_dashboard_entity.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/routing/routes.dart';

class OwnerTasksLegalCard extends StatelessWidget {
  final TasksBreakdownEntity? tasks;
  final LegalCasesBreakdownEntity? legalCases;

  const OwnerTasksLegalCard({
    super.key,
    this.tasks,
    this.legalCases,
  });

  String _formatCurrency(num amount) {
    return LocaleKeys.commonCurrencySar.tr(args: [amount.toStringAsFixed(0)]);
  }

  @override
  Widget build(BuildContext context) {
    if (tasks == null && legalCases == null) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        if (tasks != null)
          Expanded(
            child: _buildCard(
              icon: Icons.task_alt_rounded,
              title: LocaleKeys.dashboard_tasks_active.tr(),
              value: tasks!.active.toString(),
              subtitle: LocaleKeys.dashboard_tasks_overdue.tr(),
              subtitleValue: tasks!.overdue.toString(),
              color: const Color(0xFF0EA5E9),
            ),
          ),
        if (tasks != null && legalCases != null) const SizedBox(width: 16),
        if (legalCases != null)
          Expanded(
            child: GestureDetector(
              onTap: () {
                context.push(Routes.ownerLegalCases);
              },
              child: _buildCard(
                icon: Icons.gavel_rounded,
                title: LocaleKeys.dashboard_legal_open.tr(),
                value: legalCases!.openCases.toString(),
                subtitle: LocaleKeys.dashboard_legal_amount.tr(),
                subtitleValue: _formatCurrency(legalCases!.totalAmount),
                color: const Color(0xFFF59E0B),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required String subtitleValue,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.circularXxl,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: AppRadius.circularMd,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textSecondaryLight,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: AppRadius.circularMd,
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Row(
                children: [
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    subtitleValue,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
