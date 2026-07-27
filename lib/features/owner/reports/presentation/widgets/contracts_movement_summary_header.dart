import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../domain/entities/contracts_movement_summary_entity.dart';

class ContractsMovementSummaryHeader extends StatelessWidget {
  final ContractsMovementSummaryEntity summary;

  const ContractsMovementSummaryHeader({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
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
            color: context.primaryShadow.withValues(alpha: 0.4),
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
                  const Icon(Icons.sync_alt_rounded,
                      color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    LocaleKeys.contractsMovementTotalMovements.tr(),
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
                '${summary.totalMovements}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
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
                      label: LocaleKeys.contractsMovementCreations.tr(),
                      value: '${summary.creations}',
                      color: const Color(0xFF6EE7B7), // Light Emerald
                      icon: Icons.add_circle_outline_rounded,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 36,
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                  Expanded(
                    child: _miniMetric(
                      label: LocaleKeys.contractsMovementRenewals.tr(),
                      value: '${summary.renewals}',
                      color: const Color(0xFF93C5FD), // Light Blue
                      icon: Icons.autorenew_rounded,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 36,
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                  Expanded(
                    child: _miniMetric(
                      label: LocaleKeys.contractsMovementTerminations.tr(),
                      value: '${summary.terminations}',
                      color: const Color(0xFFFCA5A5), // Light Red
                      icon: Icons.cancel_outlined,
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

  Widget _miniMetric({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
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
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
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
}
