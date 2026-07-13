import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/owner_dashboard_entity.dart';

class OwnerFinancialSummaryCard extends StatelessWidget {
  final OwnerDashboardEntity data;

  const OwnerFinancialSummaryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final hasOverdue = data.overdueInstallmentsCount > 0;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [context.primaryDark, context.primaryColor, context.primaryLight], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: context.primaryShadow, blurRadius: 28, offset: const Offset(0, 12)),
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Stack(
        children: [
          _buildCircles(),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(hasOverdue),
                const SizedBox(height: 22),
                _buildHeroNumber(),
                const SizedBox(height: 20),
                Container(height: 1, color: Colors.white.withValues(alpha: 0.1)),
                const SizedBox(height: 18),
                _buildMetricsRow(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircles() => Positioned.fill(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(children: [
            Positioned(top: -40, left: -40, child: Container(width: 140, height: 140, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.04)))),
            Positioned(bottom: -30, right: -20, child: Container(width: 110, height: 110, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.05)))),
          ]),
        ),
      );

  Widget _buildHeader(bool hasOverdue) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            const Icon(Icons.account_balance_wallet_rounded, color: Colors.white60, size: 15),
            const SizedBox(width: 6),
            Text(LocaleKeys.dashboardFinancialPosition.tr(), style: const TextStyle(color: Colors.white60, fontSize: 12.5, fontWeight: FontWeight.w500)),
          ]),
          if (hasOverdue)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.error.withValues(alpha: 0.55))),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 12),
                const SizedBox(width: 4),
                Text('${data.overdueInstallmentsCount} ${LocaleKeys.dashboardOverdue.tr()}', style: const TextStyle(color: AppColors.error, fontSize: 10.5, fontWeight: FontWeight.w700)),
              ]),
            ),
        ],
      );

  Widget _buildHeroNumber() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerRight, child: Text(LocaleKeys.commonCurrencySar.tr(args: [_fmt(data.pendingAmount)]), style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w800, letterSpacing: -0.5, height: 1.1))),
          const SizedBox(height: 5),
          Row(children: [
            Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFFFBBF24), shape: BoxShape.circle)),
            const SizedBox(width: 7),
            Text(LocaleKeys.dashboardTotalDuePending.tr(), style: const TextStyle(color: Colors.white54, fontSize: 12.5)),
          ]),
        ],
      );

  Widget _buildMetricsRow() => Row(
        children: [
          Expanded(child: _miniMetric(LocaleKeys.ownerCollected.tr(), data.collectedAmount, const Color(0xFF34D399), Icons.check_circle_outline_rounded)),
          Container(width: 1, height: 36, color: Colors.white.withValues(alpha: 0.1)),
          Expanded(child: _miniMetric(LocaleKeys.ownerPending.tr(), data.pendingAmount, const Color(0xFFFBBF24), Icons.pending_actions_rounded)),
          Container(width: 1, height: 36, color: Colors.white.withValues(alpha: 0.1)),
          Expanded(child: _miniMetric(LocaleKeys.ownerTotal.tr(), data.totalRevenue, Colors.white70, Icons.bar_chart_rounded)),
        ],
      );

  Widget _miniMetric(String label, num amount, Color color, IconData icon) => Column(children: [
        Icon(icon, color: color.withValues(alpha: 0.8), size: 15),
        const SizedBox(height: 5),
        FittedBox(fit: BoxFit.scaleDown, child: Text(LocaleKeys.commonCurrencySar.tr(args: [_fmt(amount)]), style: TextStyle(color: color, fontSize: 13.5, fontWeight: FontWeight.w700))),
        const SizedBox(height: 3),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10.5, fontWeight: FontWeight.w500)),
      ]);

  String _fmt(num n) => n == n.toInt() ? n.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},') : n.toStringAsFixed(2);
}
