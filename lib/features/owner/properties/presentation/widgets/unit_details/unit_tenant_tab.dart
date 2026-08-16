import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/core/theme/color_utils.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/app_responsive_content.dart';
import '../../../../../../core/presentation/widgets/custom_empty_widget.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../domain/entities/unit_full_details_entity.dart';

class UnitTenantTab extends StatelessWidget {
  final UnitFullDetailsEntity unit;

  const UnitTenantTab({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    final tenant = unit.currentTenant;

    if (tenant == null && (unit.currentContract?.renterName.isEmpty ?? true)) {
      return CustomEmptyWidget(
        icon: Icons.person_off_outlined,
        title: LocaleKeys.unitDetailsNoTenant.tr(),
        subtitle: LocaleKeys.unitDetailsNoTenantSubtitle.tr(),
      );
    }

    final tenantName = tenant?.name.isNotEmpty == true
        ? tenant!.name
        : (unit.currentContract?.renterName ?? '');
    final tenantPhone = tenant?.phone ?? '';
    final tenantEmail = tenant?.email ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: AppResponsiveContent(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.circularXl,
            border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor:
                        context.primaryColor.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.person_rounded,
                      color: context.primaryColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tenantName,
                          style: const TextStyle(
                            fontFamily: AppFonts.fontFamilyPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          LocaleKeys.unitDetailsCurrentTenantTitle.tr(),
                          style: TextStyle(
                            fontFamily: AppFonts.fontFamilyPrimary,
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (tenantPhone.isNotEmpty || tenantEmail.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Divider(height: 1),
                const SizedBox(height: 16),
                if (tenantPhone.isNotEmpty)
                  _TenantInfoTile(
                    icon: Icons.phone_outlined,
                    label: LocaleKeys.unitDetailsTenantPhone.tr(),
                    value: tenantPhone,
                  ),
                if (tenantEmail.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _TenantInfoTile(
                    icon: Icons.email_outlined,
                    label: LocaleKeys.unitDetailsTenantEmail.tr(),
                    value: tenantEmail,
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TenantInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _TenantInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: context.primaryColor),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.fontFamilyPrimary,
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontFamily: AppFonts.fontFamilyPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
