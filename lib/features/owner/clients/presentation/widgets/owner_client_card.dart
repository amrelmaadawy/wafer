import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../../core/presentation/widgets/app_status_badge.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../domain/entities/client_entity.dart';

class OwnerClientCard extends StatelessWidget {
  final ClientEntity client;
  final VoidCallback? onTap;

  const OwnerClientCard({
    super.key,
    required this.client,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppSurfaceCard(
        onTap: onTap,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        client.name.isEmpty ? '-' : client.name,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: context.appOnSurfaceColor,
                        ),
                      ),
                      if (client.phone != null && client.phone!.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          client.phone!,
                          textDirection: ui.TextDirection.ltr,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: context.appSecondaryTextColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                AppStatusBadge(
                  labelKey: client.clientTypeLabel ?? '',
                  color: _getClientTypeColor(client.clientType ?? ''),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(
                  context,
                  LocaleKeys.drawerNavContracts.tr(),
                  client.contractsCount.toString(),
                  Icons.description_outlined,
                ),
                _buildInfoItem(
                  context,
                  LocaleKeys.drawerNavProperties.tr(),
                  client.propertiesCount.toString(),
                  Icons.domain_outlined,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: context.appSecondaryTextColor,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '$label: ',
          style: AppTextStyles.bodySmall.copyWith(
            color: context.appSecondaryTextColor,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: context.appOnSurfaceColor,
          ),
        ),
      ],
    );
  }

  Color _getClientTypeColor(String? type) {
    if (type == 'owner') return AppColors.primary;
    if (type == 'client' || type == 'tenant') return AppColors.info;
    return AppColors.textSecondaryLight;
  }
}
