import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../domain/entities/unit_full_details_entity.dart';
import '../../../../../../core/presentation/widgets/collapsible_section.dart';
import '../../../../maintenance/presentation/widgets/maintenance_card.dart';

class UnitMaintenanceSection extends StatelessWidget {
  final UnitFullDetailsEntity unit;
  
  const UnitMaintenanceSection({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    final maintenanceRequests = unit.maintenanceRequests;

    if (maintenanceRequests.isEmpty) return const SizedBox.shrink();

    return CollapsibleSection(
      title: LocaleKeys.unitsMaintenanceRequests.tr(),
      icon: Icons.build_circle_outlined,
      child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: maintenanceRequests.length,
          itemBuilder: (context, index) {
            final request = maintenanceRequests[index];
            return MaintenanceCard(
              item: request,
              onTap: () {
                context.push('/owner-maintenance-details/${request.id}');
              },
            );
          },
        ),
    );
  }
}
