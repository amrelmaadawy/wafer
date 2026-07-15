import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';

class RevenueSummaryHeader extends StatelessWidget {
  final double totalExpected;
  final double totalCollected;
  final double collectionRate;

  const RevenueSummaryHeader({
    super.key,
    required this.totalExpected,
    required this.totalCollected,
    required this.collectionRate,
  });

  @override
  Widget build(BuildContext context) {
    final overdue = (totalExpected - totalCollected).clamp(0, double.infinity);
    final ratePercent = (collectionRate * 100).toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.primaryDark,
            context.primaryColor,
            context.primaryLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.circularXxl,
        boxShadow: [
          BoxShadow(
            color: context.primaryShadow,
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          _buildBackgroundCircles(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.trending_up_rounded,
                      color: Colors.white70, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    LocaleKeys.revenueCollectionRate.tr(),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '$ratePercent%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 1,
                color: Colors.white.withValues(alpha: 0.15),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _miniMetric(
                      LocaleKeys.revenueTotalExpected.tr(),
                      totalExpected,
                      const Color(0xFFFBBF24),
                      Icons.account_balance_wallet_rounded,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 36,
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                  Expanded(
                    child: _miniMetric(
                      LocaleKeys.revenueCollected.tr(),
                      totalCollected,
                      const Color(0xFF34D399),
                      Icons.check_circle_rounded,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 36,
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                  Expanded(
                    child: _miniMetric(
                      LocaleKeys.revenueOverdue.tr(),
                      overdue.toDouble(),
                      const Color(0xFFFCA5A5),
                      Icons.warning_amber_rounded,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundCircles() {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: AppRadius.circularXxl,
        child: Stack(
          children: [
            Positioned(
              top: -40,
              left: -40,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              right: -20,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniMetric(String label, double amount, Color color, IconData icon) {
    final formatted = _formatAmount(amount);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                formatted,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}k ر.س';
    }
    return '${amount.toStringAsFixed(0)} ر.س';
  }
}
