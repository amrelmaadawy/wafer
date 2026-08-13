import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/theme/state_color_utils.dart';
import '../../../domain/entities/unit_entity.dart';

class UnitCard extends StatelessWidget {
  final UnitEntity unit;
  final VoidCallback onTap;

  const UnitCard({super.key, required this.unit, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final double displayPrice = (unit.prices.monthly > 0)
        ? unit.prices.monthly.toDouble()
        : unit.rentPrice.toDouble();

    final String formattedPrice = (displayPrice % 1 == 0)
        ? displayPrice.toInt().toString()
        : displayPrice.toStringAsFixed(2);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularXl,
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.circularXl,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.circularXl,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // â”€â”€ Header Row â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                Row(
                  children: [
                    // Unit icon with primary color bg
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: context.primarySubtle,
                        borderRadius: AppRadius.circularLg,
                      ),
                      child: Icon(
                        Icons.meeting_room_rounded,
                        color: context.primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            unit.name ??
                                LocaleKeys.dashboardUnitPrefix.tr(
                                  args: [unit.unitNumber],
                                ),
                            style: AppTextStyles.h4.copyWith(
                              color: AppColors.textPrimaryLight,
                            ),
                          ),
                          if (unit.typeLabel != null || unit.type != null)
                            Text(
                              unit.typeLabel ?? unit.type ?? '',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: StateColorUtils.getUnitTypeColor(unit.type),
                                fontWeight: AppFonts.semiBold,
                              ),
                            ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(context),
                  ],
                ),

                const SizedBox(height: 14),

                // â”€â”€ Quick Stats â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                Wrap(
                  spacing: 16,
                  runSpacing: 6,
                  children: [
                    if (unit.details.roomsCount > 0)
                      _buildStat(
                        context,
                        Icons.bed_outlined,
                        LocaleKeys.commonRooms.tr(
                          args: [unit.details.roomsCount.toString()],
                        ),
                      ),
                    if (unit.details.bathroomsCount > 0)
                      _buildStat(
                        context,
                        Icons.bathtub_outlined,
                        LocaleKeys.commonBathrooms.tr(
                          args: [unit.details.bathroomsCount.toString()],
                        ),
                      ),
                    if (unit.area != null && unit.area! > 0)
                      _buildStat(
                        context,
                        Icons.square_foot_outlined,
                        LocaleKeys.commonAreaM2.tr(
                          args: [unit.area!.toStringAsFixed(0)],
                        ),
                      ),
                    if (unit.floor != null && unit.floor!.isNotEmpty)
                      _buildStat(
                        context,
                        Icons.layers_outlined,
                        LocaleKeys.unit_details_floor_prefix.tr(
                          args: [unit.floor!],
                        ),
                      ),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: AppColors.dividerSubtleLight, height: 1),
                ),

                // â”€â”€ Bottom Row: furnished + code + price â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                Row(
                  children: [
                    // Furnished chip
                    _buildChip(
                      icon: unit.isFurnished
                          ? Icons.chair_outlined
                          : Icons.chair_alt_outlined,
                      label: unit.isFurnished
                          ? LocaleKeys.commonFurnished.tr()
                          : LocaleKeys.commonUnfurnished.tr(),
                      color: unit.isFurnished
                          ? context.primaryColor
                          : AppColors.textSecondaryLight,
                    ),
                    if (unit.code != null) ...[
                      const SizedBox(width: 8),
                      _buildChip(
                        icon: Icons.tag_rounded,
                        label: unit.code!,
                        color: AppColors.textSecondaryLight,
                      ),
                    ],
                    const Spacer(),
                    // Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          LocaleKeys.commonCurrencySar.tr(
                            args: [formattedPrice],
                          ),
                          style: AppTextStyles.h4.copyWith(
                            color: context.primaryColor,
                          ),
                        ),
                        if (unit.prices.monthly > 0)
                          Text(
                            LocaleKeys.unit_details_monthly.tr(),
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: context.primaryColor),
        const SizedBox(width: 5),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textPrimaryLight,
            fontWeight: AppFonts.semiBold,
          ),
        ),
      ],
    );
  }

  Widget _buildChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.labelSmall.copyWith(color: color)),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    Color color = StateColorUtils.getStatusColor(unit.status);
    String label = unit.statusLabel?.isNotEmpty == true
        ? unit.statusLabel!
        : (unit.status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: AppRadius.circularFull,
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: color,
          fontWeight: AppFonts.bold,
        ),
      ),
    );
  }
}

