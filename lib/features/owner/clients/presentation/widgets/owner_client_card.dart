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
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/presentation/widgets/app_confirm_dialog.dart';
import '../../domain/entities/client_entity.dart';
import '../cubit/list/owner_clients_list_cubit.dart';
import '../cubit/delete/delete_owner_client_cubit.dart';
import 'update_client_bottom_sheet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final primaryColor = context.primaryColor;
    final String initial = client.name.trim().isNotEmpty 
        ? client.name.trim().substring(0, 1).toUpperCase() 
        : '?';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppSurfaceCard(
        onTap: onTap,
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Client Avatar
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      initial,
                      style: AppTextStyles.h4.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  // Client Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                client.name.isEmpty ? '-' : client.name,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: context.appOnSurfaceColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            AppStatusBadge(
                              labelKey: _getClientTypeLabelKey(client.clientType),
                              color: _getClientTypeColor(client.clientType),
                            ),
                          ],
                        ),
                        if (client.phone != null && client.phone!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            client.phone!,
                            textDirection: ui.TextDirection.ltr,
                            textAlign: context.locale.languageCode == 'ar' 
                                ? TextAlign.right 
                                : TextAlign.left,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: context.appSecondaryTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Footer Section (Stats & Actions)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, 
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: context.appBorderColor.withValues(alpha: 0.2),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16), // Match AppSurfaceCard default radius
                ),
              ),
              child: Row(
                children: [
                  // Stats
                  Expanded(
                    child: Wrap(
                      spacing: AppSpacing.md,
                      runSpacing: AppSpacing.xs,
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
                  ),
                  
                  // Actions
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildActionButton(
                        context,
                        icon: Icons.edit_rounded,
                        color: context.primaryColor,
                        onTap: () {
                          UpdateClientBottomSheet.show(
                            context,
                            client,
                            () {
                              context.read<OwnerClientsListCubit>().loadClients(forceRefresh: true);
                            },
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildActionButton(
                        context,
                        icon: Icons.delete_outline_rounded,
                        color: AppColors.error,
                        onTap: () async {
                          final confirmed = await AppConfirmDialog.show(
                            context: context,
                            titleKey: LocaleKeys.clientsDeleteTitle,
                            messageKey: LocaleKeys.clientsDeleteMessage,
                          );
                          if (confirmed == true && context.mounted) {
                            context.read<DeleteOwnerClientCubit>().deleteClient(client.id);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, {
    required IconData icon, 
    required Color color, 
    required VoidCallback onTap
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: color,
          ),
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
          size: 14,
          color: context.appSecondaryTextColor,
        ),
        const SizedBox(width: 4),
        Text(
          '$label: ',
          style: AppTextStyles.bodySmall.copyWith(
            color: context.appSecondaryTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(
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

  String _getClientTypeLabelKey(String? type) {
    if (type == 'owner') return LocaleKeys.clientTypeOwner;
    if (type == 'tenant') return LocaleKeys.clientTypeTenant;
    if (type == 'client') return LocaleKeys.clientTypeClient;
    return '';
  }
}

