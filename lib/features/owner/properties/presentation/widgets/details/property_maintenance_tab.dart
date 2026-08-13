import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/custom_empty_widget.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/routing/routes.dart';
import 'package:wafer/features/owner/maintenance/domain/entities/maintenance_item_entity.dart';
import 'package:wafer/features/owner/maintenance/presentation/widgets/maintenance_card.dart';
import 'package:wafer/features/owner/maintenance/domain/entities/maintenance_sub_entities.dart';
import '../../../domain/entities/maintenance_entity.dart';

class PropertyMaintenanceTab extends StatelessWidget {
  final List<MaintenanceEntity> maintenanceRequests;

  const PropertyMaintenanceTab({super.key, required this.maintenanceRequests});

  @override
  Widget build(BuildContext context) {
    if (maintenanceRequests.isEmpty) {
      return CustomEmptyWidget(
        icon: Icons.handyman_outlined,
        title: LocaleKeys.maintenanceNoRequestsTitle.tr(),
        subtitle: LocaleKeys.dashboard_no_data.tr(),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: maintenanceRequests.length,
      itemBuilder: (context, index) {
        final request = maintenanceRequests[index];
        final itemEntity = _mapToItemEntity(request);

        return MaintenanceCard(
          item: itemEntity,
          onTap: () {
            context.push(
              Routes.ownerMaintenanceDetails,
              extra: itemEntity,
            );
          },
        );
      },
    );
  }

  MaintenanceItemEntity _mapToItemEntity(MaintenanceEntity request) {
    return MaintenanceItemEntity(
      id: request.id,
      requestNumber: request.requestNumber,
      title: '', // Property maintenance tab didn't show a title originally
      description: request.description,
      status: request.status,
      statusLabel: request.statusLabel,
      property: null, // the tab is already inside property details
      unit: MaintenanceUnitRefEntity(id: 0, name: request.unitName),
      client: const MaintenanceClientEntity(name: '', phone: ''), // client name was not in MaintenanceEntity
      costBearer: '',
      costBearerLabel: '',
      financials: MaintenanceFinancialsEntity(
        estimatedCost: request.estimatedCost,
        actualCost: 0,
        advancePayment: 0,
      ),
      dates: MaintenanceDatesEntity(
        requestedDate: request.requestedDate,
      ),
    );
  }
}


