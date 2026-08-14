import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/locale_keys.dart';

class OwnerNavigationDestination {
  final String label;
  final IconData selectedIcon;
  final IconData icon;

  const OwnerNavigationDestination({
    required this.label,
    required this.selectedIcon,
    required this.icon,
  });
}

List<OwnerNavigationDestination> ownerNavigationDestinations() => [
  OwnerNavigationDestination(
    label: LocaleKeys.dashboardNavHome.tr(),
    selectedIcon: Icons.dashboard_rounded,
    icon: Icons.dashboard_outlined,
  ),
  OwnerNavigationDestination(
    label: LocaleKeys.dashboardNavProperties.tr(),
    selectedIcon: Icons.apartment_rounded,
    icon: Icons.apartment_outlined,
  ),
  OwnerNavigationDestination(
    label: LocaleKeys.dashboardNavContracts.tr(),
    selectedIcon: Icons.description_rounded,
    icon: Icons.description_outlined,
  ),
  OwnerNavigationDestination(
    label: LocaleKeys.dashboardNavFinance.tr(),
    selectedIcon: Icons.account_balance_wallet_rounded,
    icon: Icons.account_balance_wallet_outlined,
  ),
  OwnerNavigationDestination(
    label: LocaleKeys.owner_more_title.tr(),
    selectedIcon: Icons.more_horiz_rounded,
    icon: Icons.more_horiz_outlined,
  ),
];
