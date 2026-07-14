import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/color_utils.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileHeaderCard extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileHeaderCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final initials = profile.name.isNotEmpty
        ? profile.name.trim().split(' ').take(2)
            .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '').join()
        : 'U';
    final primary = context.primaryColor;

    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadius.circularXxl,
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            primary,
            primary.withValues(alpha: 0.8),
            primary.withValues(alpha: 0.65),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: context.primaryShadow,
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Decorative circles
          Positioned(
            top: -30,
            left: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            right: -30,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildAvatar(context, initials),
                  const SizedBox(height: 16),
                  Text(
                    profile.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '@${profile.username}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildBadgesRow(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, String initials) {
    return Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipOval(
        child: (profile.avatar != null && profile.avatar!.isNotEmpty)
            ? Image.network(
                profile.avatar!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _initialsWidget(context, initials),
              )
            : _initialsWidget(context, initials),
      ),
    );
  }

  Widget _initialsWidget(BuildContext context, String initials) {
    return Container(
      color: Colors.white.withValues(alpha: 0.25),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBadgesRow(BuildContext context) {
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
          label: profile.isActive ? LocaleKeys.profileActive.tr() : LocaleKeys.profileInactive.tr(),
          icon: profile.isActive ? Icons.verified_rounded : Icons.cancel_rounded,
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
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  String _accountTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'owner':  return LocaleKeys.profileOwnerType.tr();
      case 'company': return LocaleKeys.profileCompanyType.tr();
      case 'tenant':  return LocaleKeys.profileTenantType.tr();
      default:        return type;
    }
  }
}
