import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/color_utils.dart';
import '../../../../core/utils/widgets/app_toast.dart';
import '../../domain/entities/profile_entity.dart';
import 'profile_info_tile.dart';

class ProfileInfoCard extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileInfoCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final expiringSoon = _isExpiringSoon(profile.identityExpiry);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.person_outline_rounded, color: context.primaryColor, size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  'المعلومات الشخصية',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.borderLight),
          // Rows
          ProfileInfoTile(
            icon: Icons.phone_android_rounded,
            label: 'رقم الهاتف',
            value: profile.phone,
            onCopy: () => _copy(context, 'رقم الهاتف', profile.phone),
          ),
          const Divider(height: 1, color: AppColors.borderLight, indent: 20, endIndent: 20),
          ProfileInfoTile(
            icon: Icons.email_outlined,
            label: 'البريد الإلكتروني',
            value: profile.email,
            onCopy: () => _copy(context, 'البريد الإلكتروني', profile.email),
          ),
          const Divider(height: 1, color: AppColors.borderLight, indent: 20, endIndent: 20),
          ProfileInfoTile(
            icon: Icons.badge_outlined,
            label: 'رقم الهوية',
            value: profile.identityNumber,
            onCopy: () => _copy(context, 'رقم الهوية', profile.identityNumber),
          ),
          const Divider(height: 1, color: AppColors.borderLight, indent: 20, endIndent: 20),
          ProfileInfoTile(
            icon: Icons.event_outlined,
            label: 'انتهاء الهوية',
            value: profile.identityExpiry,
            trailing: expiringSoon ? _expiryBadge() : null,
          ),
          const Divider(height: 1, color: AppColors.borderLight, indent: 20, endIndent: 20),
          ProfileInfoTile(
            icon: Icons.wc_rounded,
            label: 'الجنس',
            value: profile.gender.toLowerCase() == 'male' ? 'ذكر' : 'أنثى',
          ),
          const Divider(height: 1, color: AppColors.borderLight, indent: 20, endIndent: 20),
          ProfileInfoTile(
            icon: Icons.calendar_month_outlined,
            label: 'تاريخ الانضمام',
            value: profile.joinedAt,
          ),
          if (expiringSoon) ...[
            const SizedBox(height: 4),
            _expiryWarningBanner(context),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _expiryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'تنتهي قريباً',
        style: TextStyle(color: AppColors.error, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _expiryWarningBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'الهوية قريبة من الانتهاء أو منتهية — يُنصح بالتحديث لضمان الخدمة.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _copy(BuildContext context, String label, String value) {
    if (value.isEmpty) return;
    Clipboard.setData(ClipboardData(text: value));
    AppToast.showSuccess(context, 'تم نسخ $label بنجاح', title: 'تم النسخ');
  }

  bool _isExpiringSoon(String expiry) {
    if (expiry.isEmpty) return false;
    try {
      return DateTime.parse(expiry).difference(DateTime.now()).inDays <= 30;
    } catch (_) {
      return false;
    }
  }
}
