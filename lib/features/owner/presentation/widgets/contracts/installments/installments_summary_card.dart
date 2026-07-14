import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../domain/entities/contract_installment_entity.dart';

class InstallmentsSummaryCard extends StatelessWidget {
  final List<ContractInstallmentEntity> installments;

  const InstallmentsSummaryCard({super.key, required this.installments});

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.primaryColor;

    double totalAmount = 0.0;
    double totalPaid = 0.0;
    double totalRemaining = 0.0;
    int paidCount = 0;

    for (final inst in installments) {
      totalAmount += inst.amount;
      totalPaid += inst.paidAmount;
      totalRemaining += inst.remaining;
      if (inst.status == 'paid') paidCount++;
    }

    final double progress = totalAmount > 0
        ? (totalPaid / totalAmount).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadius.circularLg,
        gradient: LinearGradient(
          colors: [
            primaryColor,
            Color.lerp(primaryColor, Colors.black, 0.28)!,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.38),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -30,
            left: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          LocaleKeys.installmentsTitle.tr(),
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    // Paid count badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$paidCount / ${installments.length}',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Three metrics
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      _buildMetric(
                        label: LocaleKeys.installmentsTotalAmount.tr(),
                        value: totalAmount,
                        valueColor: Colors.white,
                        icon: Icons.receipt_long_rounded,
                      ),
                      _buildVerticalDivider(),
                      _buildMetric(
                        label: LocaleKeys.installmentsPaidAmount.tr(),
                        value: totalPaid,
                        valueColor: const Color(0xFF86EFAC),
                        icon: Icons.check_circle_rounded,
                        iconColor: const Color(0xFF86EFAC),
                      ),
                      _buildVerticalDivider(),
                      _buildMetric(
                        label: LocaleKeys.installmentsRemainingAmount.tr(),
                        value: totalRemaining,
                        valueColor: const Color(0xFFFDE047),
                        icon: Icons.pending_rounded,
                        iconColor: const Color(0xFFFDE047),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Progress section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${(progress * 100).toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          LocaleKeys.installmentsPaidAmount.tr(),
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Colors.white.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ),
                    // Circular progress
                    SizedBox(
                      width: 52,
                      height: 52,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 5,
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF86EFAC),
                            ),
                          ),
                          Text(
                            '$paidCount',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Linear progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 7,
                    backgroundColor: Colors.white.withValues(alpha: 0.18),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF86EFAC),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric({
    required String label,
    required double value,
    required Color valueColor,
    required IconData icon,
    Color iconColor = Colors.white,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 16, color: iconColor.withValues(alpha: 0.85)),
          const SizedBox(height: 6),
          Text(
            value.toStringAsFixed(0),
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              color: Colors.white.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 60,
      color: Colors.white.withValues(alpha: 0.15),
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}
