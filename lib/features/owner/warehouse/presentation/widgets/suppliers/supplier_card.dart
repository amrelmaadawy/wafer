import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/theme_context.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/presentation/widgets/app_status_badge.dart';
import '../../../domain/entities/suppliers/supplier_entity.dart';

class SupplierCard extends StatelessWidget {
  final SupplierEntity supplier;
  final VoidCallback? onTap;

  const SupplierCard({
    super.key,
    required this.supplier,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appSurfaceColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: context.appBorderColor,
          width: 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: context.primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.local_shipping_rounded, color: context.primaryColor, size: 24),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            supplier.companyName,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            supplier.supplierCode,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: context.appSecondaryTextColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppStatusBadge(
                      color: supplier.isActive ? AppColors.success : AppColors.error,
                      labelKey: supplier.statusLabel,
                      translateText: false,
                    ),
                  ],
                ),
                if (supplier.contactPerson != null || supplier.phone != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Divider(height: 1, color: context.appBorderColor),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (supplier.contactPerson != null)
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.person_rounded, size: 18, color: context.appSecondaryTextColor),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  supplier.contactPerson!,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: context.appSecondaryTextColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (supplier.phone != null || supplier.companyPhone != null)
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Text(
                                  (supplier.phone ?? supplier.companyPhone)!,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: context.appSecondaryTextColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textDirection: TextDirection.ltr,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(Icons.phone_rounded, size: 18, color: context.appSecondaryTextColor),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
