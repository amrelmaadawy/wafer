import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/unit_full_details_entity.dart';
import '../../../../maintenance/presentation/widgets/maintenance_card.dart';

class UnitMaintenanceSection extends StatelessWidget {
  final UnitFullDetailsEntity unit;
  
  const UnitMaintenanceSection({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    final maintenanceRequests = unit.maintenanceRequests;

    if (maintenanceRequests.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.1),
                borderRadius: AppRadius.circularMd,
              ),
              child: Icon(
                Icons.build_circle_outlined,
                color: context.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              LocaleKeys.unitsMaintenanceRequests.tr(),
              style: AppTextStyles.h4,
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
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
      ],
    );
  }
}
