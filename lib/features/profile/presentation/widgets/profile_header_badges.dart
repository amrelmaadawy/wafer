import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileHeaderBadges extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileHeaderBadges({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 8,
      children: [
        _buildBadge(
          label: _accountTypeLabel(profile.accountType),
          icon: Icons.workspace_premium_rounded,
        ),
        _buildBadge(
          label: profile.isActive
              ? LocaleKeys.profile_active.tr()
              : LocaleKeys.profile_inactive.tr(),
          icon: profile.isActive
              ? Icons.verified_rounded
              : Icons.cancel_rounded,
          bgColor: profile.isActive
              ? Colors.white.withValues(alpha: 0.2)
              : AppColors.error.withValues(alpha: 0.4),
        ),
      ],
    );
  }

  Widget _buildBadge({
    required String label,
    required IconData icon,
    Color? bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor ?? Colors.white.withValues(alpha: 0.2),
        borderRadius: AppRadius.circularFull,
        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _accountTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'owner':
        return LocaleKeys.profile_owner_type.tr();
      case 'company':
        return LocaleKeys.profile_company_type.tr();
      case 'tenant':
        return LocaleKeys.profile_tenant_type.tr();
      default:
        return type;
    }
  }
}
