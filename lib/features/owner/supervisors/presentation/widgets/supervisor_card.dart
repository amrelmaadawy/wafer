import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../domain/entities/supervisor_entity.dart';
import '../../../../../../core/theme/color_utils.dart';

class SupervisorCard extends StatelessWidget {
  final SupervisorEntity supervisor;

  const SupervisorCard({super.key, required this.supervisor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: context.primaryShadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAvatarWithStatus(context),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      supervisor.user?.name ?? '-',
                      style: AppTextStyles.h4.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimaryLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    _buildScopeBadge(context),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Divider(color: AppColors.borderLight, height: 1),
          ),
          if (supervisor.user?.phone != null) ...[
            _buildIconText(
              context,
              Icons.phone_android_outlined,
              supervisor.user!.phone!,
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
          if (supervisor.user?.email != null) ...[
            _buildIconText(
              context,
              Icons.mail_outline_rounded,
              supervisor.user!.email!,
            ),
          ],
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
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: context.primaryFaint,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 14, color: context.primaryColor),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondaryLight,
            ),
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
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
