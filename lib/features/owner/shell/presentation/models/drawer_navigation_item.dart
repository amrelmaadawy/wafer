import 'package:flutter/material.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/routing/routes.dart';

/// Base class for all items rendered in the Navigation Drawer.
abstract class DrawerNavEntry {
  const DrawerNavEntry();

  /// Check if the entry is accessible for the specified user account type.
  bool isAllowedFor(String? accountType);
}

/// A leaf destination item in the Drawer (can be top-level or inside a section).
class DrawerNavItem extends DrawerNavEntry {
  final String labelKey;
  final IconData icon;
  final IconData? activeIcon;
  final int? branchIndex;
  final String? route;
  final int badgeCount;
  final List<String>? allowedAccountTypes;

  const DrawerNavItem({
    required this.labelKey,
    required this.icon,
    this.activeIcon,
    this.branchIndex,
    this.route,
    this.badgeCount = 0,
    this.allowedAccountTypes,
  });

  IconData get effectiveActiveIcon => activeIcon ?? icon;

  @override
  bool isAllowedFor(String? accountType) {
    if (allowedAccountTypes == null || allowedAccountTypes!.isEmpty) {
      return true;
    }
    if (accountType == null || accountType.isEmpty) {
      return true; // Default fallback if profile is loading
    }
    final normalized = accountType.toLowerCase().trim();
    return allowedAccountTypes!.map((e) => e.toLowerCase()).contains(normalized);
  }
}

/// A collapsible/expandable single-level group in the Drawer.
class DrawerNavSection extends DrawerNavEntry {
  final String titleKey;
  final IconData icon;
  final List<DrawerNavItem> items;
  final List<String>? allowedAccountTypes;

  const DrawerNavSection({
    required this.titleKey,
    required this.icon,
    required this.items,
    this.allowedAccountTypes,
  });

  /// Check if this section contains the given branch index.
  bool containsBranchIndex(int branchIndex) {
    return items.any((item) => item.branchIndex == branchIndex);
  }

  /// Returns items within this section that are visible to the given account type.
  List<DrawerNavItem> visibleItems(String? accountType) {
    return items.where((item) => item.isAllowedFor(accountType)).toList();
  }

  @override
  bool isAllowedFor(String? accountType) {
    if (allowedAccountTypes != null && allowedAccountTypes!.isNotEmpty) {
      final normalized = (accountType ?? '').toLowerCase().trim();
      if (!allowedAccountTypes!.map((e) => e.toLowerCase()).contains(normalized)) {
        return false;
      }
    }
    return visibleItems(accountType).isNotEmpty;
  }
}

/// A visual divider in the Drawer list.
class DrawerNavDivider extends DrawerNavEntry {
  const DrawerNavDivider();

  @override
  bool isAllowedFor(String? accountType) => true;
}

/// Canonical Drawer navigation items configuration for Owner ERP.
class OwnerDrawerConfig {
  OwnerDrawerConfig._();

  // Standard Account Types
  static const String accountOwner = 'owner';
  static const String accountCompany = 'company';
  static const String accountTenant = 'tenant';
  static const String accountSystem = 'system';

  // Branch index constants matching StatefulShellRoute branches
  static const int branchDashboard = 0;
  static const int branchProperties = 1;
  static const int branchContracts = 2;
  static const int branchFinance = 3;
  static const int branchMaintenance = 4;
  static const int branchTasks = 5;
  static const int branchLegalCases = 6;
  static const int branchDeeds = 7;
  static const int branchTechnicians = 8;
  static const int branchSupervisors = 9;
  static const int branchNegotiations = 10;
  static const int branchReports = 11;
  static const int branchProfile = 12;
  static const int branchUnits = 13;
  static const int branchSettings = 14;
  static const int branchClients = 15;
  static const int branchWarehouseSummary = 16;
  static const int branchWarehousesList = 17;
  static const int branchWarehouseItems = 18;
  static const int branchWarehouseSuppliers = 19;

  /// Returns the raw complete ordered business module structure for the Drawer.
  static List<DrawerNavEntry> getEntries() {
    return const [
      // 1. "لوحة المعلومات" (Dashboard Top Level)
      DrawerNavItem(
        labelKey: LocaleKeys.drawerNavHome,
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        branchIndex: branchDashboard,
        route: Routes.ownerDashboard,
      ),

      // 2. "إدارة الأملاك" (Operations/Property Management Section)
      DrawerNavSection(
        titleKey: LocaleKeys.drawerSectionOperations,
        icon: Icons.apartment_outlined,
        items: [
          DrawerNavItem(
            labelKey: LocaleKeys.drawerNavProperties,
            icon: Icons.apartment_outlined,
            activeIcon: Icons.apartment_rounded,
            branchIndex: branchProperties,
            route: Routes.ownerProperties,
            allowedAccountTypes: [accountOwner, accountCompany, accountSystem],
          ),
          DrawerNavItem(
            labelKey: LocaleKeys.drawerNavUnits,
            icon: Icons.door_front_door_outlined,
            activeIcon: Icons.door_front_door_rounded,
            branchIndex: branchUnits,
            route: Routes.ownerUnitsList,
            allowedAccountTypes: [accountOwner, accountCompany, accountSystem],
          ),
          DrawerNavItem(
            labelKey: LocaleKeys.clients,
            icon: Icons.people_outline_rounded,
            activeIcon: Icons.people_rounded,
            branchIndex: branchClients,
            route: Routes.ownerClientsList,
            allowedAccountTypes: [accountOwner, accountCompany, accountSystem],
          ),
          DrawerNavItem(
            labelKey: LocaleKeys.drawerNavSupervisors,
            icon: Icons.layers_outlined,
            activeIcon: Icons.layers_rounded,
            branchIndex: branchSupervisors,
            route: Routes.ownerSupervisorsList,
            allowedAccountTypes: [accountOwner, accountCompany, accountSystem],
          ),
          DrawerNavItem(
            labelKey: LocaleKeys.drawerNavMaintenance,
            icon: Icons.build_circle_outlined,
            activeIcon: Icons.build_circle_rounded,
            branchIndex: branchMaintenance,
            route: Routes.ownerMaintenance,
          ),
          DrawerNavItem(
            labelKey: LocaleKeys.drawerNavTechnicians,
            icon: Icons.engineering_outlined,
            activeIcon: Icons.engineering_rounded,
            branchIndex: branchTechnicians,
            route: Routes.ownerTechniciansList,
            allowedAccountTypes: [accountOwner, accountCompany, accountSystem],
          ),
          DrawerNavItem(
            labelKey: LocaleKeys.drawerNavContracts,
            icon: Icons.description_outlined,
            activeIcon: Icons.description_rounded,
            branchIndex: branchContracts,
            route: Routes.ownerContracts,
            allowedAccountTypes: [accountOwner, accountCompany, accountSystem],
          ),
          DrawerNavItem(
            labelKey: LocaleKeys.drawerNavLegalCases,
            icon: Icons.gavel_outlined,
            activeIcon: Icons.gavel_rounded,
            branchIndex: branchLegalCases,
            route: Routes.ownerLegalCases,
            allowedAccountTypes: [accountOwner, accountCompany, accountSystem],
          ),
          DrawerNavItem(
            labelKey: LocaleKeys.drawerNavTasks,
            icon: Icons.task_alt_outlined,
            activeIcon: Icons.task_alt_rounded,
            branchIndex: branchTasks,
            route: Routes.ownerTasks,
            allowedAccountTypes: [accountOwner, accountCompany, accountSystem],
          ),
        ],
      ),

      // 3. Warehouse Section (New)
      DrawerNavSection(
        titleKey: LocaleKeys.warehouse_dashboard_title,
        icon: Icons.inventory_2_outlined,
        allowedAccountTypes: [accountOwner, accountCompany, accountSystem],
        items: [
          DrawerNavItem(
            labelKey: LocaleKeys.warehouse_summary_title,
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard_rounded,
            branchIndex: branchWarehouseSummary,
              route: Routes.ownerWarehouse,
          ),
          DrawerNavItem(
            labelKey: LocaleKeys.warehouse_warehouses_list_title,
            icon: Icons.store_outlined,
            activeIcon: Icons.store_rounded,
            branchIndex: branchWarehousesList,
              route: Routes.ownerWarehousesList,
          ),
          DrawerNavItem(
            labelKey: LocaleKeys.warehouse_items_list_title,
            icon: Icons.list_alt_outlined,
            activeIcon: Icons.list_alt_rounded,
            branchIndex: branchWarehouseItems,
              route: Routes.ownerWarehouseItems,
          ),
          DrawerNavItem(
            labelKey: LocaleKeys.warehouse_suppliers_title,
            icon: Icons.local_shipping_outlined,
            activeIcon: Icons.local_shipping_rounded,
            branchIndex: branchWarehouseSuppliers,
            route: Routes.ownerWarehouseSuppliers,
          ),
        ],
      ),

      // 4. "الحسابات المالية" (Documents/Finance Section)
      DrawerNavSection(
        titleKey: LocaleKeys.drawerSectionDocuments,
        icon: Icons.account_balance_wallet_outlined,
        allowedAccountTypes: [accountOwner, accountCompany, accountSystem],
        items: [
          DrawerNavItem(
            labelKey: LocaleKeys.drawerNavFinance,
            icon: Icons.account_balance_wallet_outlined,
            activeIcon: Icons.account_balance_wallet_rounded,
            branchIndex: branchFinance,
            route: Routes.ownerFinance,
            allowedAccountTypes: [accountOwner, accountCompany, accountSystem],
          ),
        ],
      ),



      // 5. Activity, Support, Reports (Top Level Items)
      DrawerNavItem(
        labelKey: LocaleKeys.drawerNavProfile,
        icon: Icons.person_outline_rounded,
        branchIndex: branchProfile,
      ),
      DrawerNavItem(
        labelKey: LocaleKeys.drawerNavSettings,
        icon: Icons.settings_outlined,
        branchIndex: branchSettings,
        route: Routes.ownerSettings,
      ),

      DrawerNavItem(
        labelKey: LocaleKeys.drawerNavReports,
        icon: Icons.bar_chart_outlined,
        activeIcon: Icons.bar_chart_rounded,
        branchIndex: branchReports,
        route: Routes.ownerReportsCenter,
        allowedAccountTypes: [accountOwner, accountCompany, accountSystem],
      ),

    ];
  }

  /// Returns the filtered business module structure based on the user's account type.
  static List<DrawerNavEntry> getFilteredEntries(String? accountType) {
    final entries = getEntries();
    final filtered = <DrawerNavEntry>[];

    for (final entry in entries) {
      if (!entry.isAllowedFor(accountType)) continue;

      if (entry is DrawerNavSection) {
        final visibleSubItems = entry.visibleItems(accountType);
        if (visibleSubItems.isNotEmpty) {
          filtered.add(
            DrawerNavSection(
              titleKey: entry.titleKey,
              icon: entry.icon,
              items: visibleSubItems,
              allowedAccountTypes: entry.allowedAccountTypes,
            ),
          );
        }
      } else {
        filtered.add(entry);
      }
    }

    return filtered;
  }
}
