import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../../core/localization/locale_keys.dart';
import '../../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../../core/theme/app_radius.dart';
import '../../../../../../../../core/theme/color_utils.dart';
import '../../../../cubit/owners/sync_owners_state.dart';

class SyncSheetHeader extends StatelessWidget {
  final SyncOwnersState state;

  const SyncSheetHeader({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final primary = context.primaryColor;
    
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, const Color(0xFFF8FAFC)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: AppRadius.circularFull,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primary.withValues(alpha: 0.2), primary.withValues(alpha: 0.05)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: AppRadius.circularLg,
                  border: Border.all(color: primary.withValues(alpha: 0.1)),
                ),
                child: Icon(Icons.people_alt_rounded, color: primary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.propertyOwnersSheetTitle.tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimaryLight,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "قم بتوزيع الحصص وتحديد الممثل القانوني",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, size: 20, color: AppColors.textPrimaryLight),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _PercentageBar(state: state),
        ],
      ),
    );
  }
}

class _PercentageBar extends StatelessWidget {
  final SyncOwnersState state;
  const _PercentageBar({required this.state});

  @override
  Widget build(BuildContext context) {
    final total = state.totalPercentage;
    final isValid = state.isValid;
    final primary = context.primaryColor;
    
    final barColor = isValid
        ? const Color(0xFF10B981) // Vibrant Emerald
        : total > 100
            ? const Color(0xFFEF4444) // Vibrant Red
            : total >= 50
                ? const Color(0xFFF59E0B) // Vibrant Amber
                : primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.circularXl,
        border: Border.all(color: const Color(0xFFE2E8F0).withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: barColor.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.propertyOwnersTotalPercentage.tr(),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: barColor.withValues(alpha: 0.1),
                  borderRadius: AppRadius.circularFull,
                ),
                child: Text(
                  '${total.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: barColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: AppRadius.circularFull,
                  boxShadow: const [
                    BoxShadow(color: Color(0xFFE2E8F0), blurRadius: 2),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                height: 10,
                width: MediaQuery.of(context).size.width * ((total / 100).clamp(0.0, 1.0)) * 0.8, // Approximation for animation width
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [barColor.withValues(alpha: 0.7), barColor],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: AppRadius.circularFull,
                  boxShadow: [
                    BoxShadow(
                      color: barColor.withValues(alpha: 0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!isValid && state.assignedOwners.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 14, color: barColor),
                const SizedBox(width: 6),
                Text(
                  LocaleKeys.propertyOwnersValidationError.tr(),
                  style: TextStyle(
                    fontSize: 12,
                    color: barColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
