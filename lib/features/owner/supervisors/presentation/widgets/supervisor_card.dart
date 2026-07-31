import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../domain/entities/supervisor_entity.dart';
import '../../../../../../core/theme/color_utils.dart';

class SupervisorCard extends StatelessWidget {
  final SupervisorEntity supervisor;

  const SupervisorCard({
    super.key,
    required this.supervisor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularMd,
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: context.primaryShadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatarWithStatus(context),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        supervisor.user?.name ?? '-',
                        style: AppTextStyles.h4,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _buildScopeBadge(context),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                if (supervisor.user?.phone != null) ...[
                  _buildIconText(context, Icons.phone_outlined, supervisor.user!.phone!),
                  const SizedBox(height: AppSpacing.xs),
                ],
                if (supervisor.user?.email != null) ...[
                  _buildIconText(context, Icons.email_outlined, supervisor.user!.email!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarWithStatus(BuildContext context) {
    final name = supervisor.user?.name ?? '?';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Stack(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: context.primaryFaint,
          child: Text(
            initial,
            style: AppTextStyles.h3.copyWith(color: context.primaryColor),
          ),
        ),
        Positioned.directional(
          textDirection: Directionality.of(context),
          bottom: 0,
          end: 0,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: supervisor.isActive ? AppColors.success : AppColors.error,
              border: Border.all(color: AppColors.surfaceLight, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconText(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondaryLight),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondaryLight),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  Widget _buildScopeBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: context.primaryFaint,
        borderRadius: AppRadius.circularSm,
      ),
      child: Text(
        supervisor.scope?.typeLabel ?? '-',
        style: AppTextStyles.labelSmall.copyWith(
          color: context.primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
