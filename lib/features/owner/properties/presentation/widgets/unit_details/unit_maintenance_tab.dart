import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:wafer/core/localization/locale_keys.dart';
import 'package:wafer/core/presentation/widgets/custom_empty_widget.dart';
import 'package:wafer/core/routing/routes.dart';
import 'package:wafer/features/owner/maintenance/domain/entities/maintenance_item_entity.dart';
import 'package:wafer/features/owner/maintenance/presentation/widgets/maintenance_card.dart';

class UnitMaintenanceTab extends StatelessWidget {
  final List<MaintenanceItemEntity> maintenanceRequests;

  const UnitMaintenanceTab({super.key, required this.maintenanceRequests});

  @override
  Widget build(BuildContext context) {
    if (maintenanceRequests.isEmpty) {
      return CustomEmptyWidget(
        icon: Icons.handyman_outlined,
        title: LocaleKeys.unitDetailsNoMaintenance.tr(),
        subtitle: LocaleKeys.dashboard_no_data.tr(),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: maintenanceRequests.length,
      itemBuilder: (context, index) {
        final request = maintenanceRequests[index];
        return MaintenanceCard(
          item: request,
          onTap: () {
            context.push(
              Routes.ownerMaintenanceDetails,
              extra: request,
            );
          },
        );
      },
    );
  }
}
