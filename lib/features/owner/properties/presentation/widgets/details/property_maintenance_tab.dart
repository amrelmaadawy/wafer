import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/maintenance_entity.dart';

class PropertyMaintenanceTab extends StatelessWidget {
  final List<MaintenanceEntity> maintenanceRequests;

  const PropertyMaintenanceTab({
    super.key,
    required this.maintenanceRequests,
  });

  @override
  Widget build(BuildContext context) {
    if (maintenanceRequests.isEmpty) {
      return Center(child: Text(LocaleKeys.maintenanceNoRequestsTitle.tr()));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: maintenanceRequests.length,
      itemBuilder: (context, index) {
        final request = maintenanceRequests[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      request.requestNumber,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.info.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        request.statusLabel,
                        style: const TextStyle(
                          color: AppColors.info,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('${LocaleKeys.unitDetailsDescription.tr()}: ${request.description}', style: const TextStyle(color: Colors.black87)),
                const SizedBox(height: 4),
                Text('${LocaleKeys.maintenanceUnitLabel.tr()}: ${request.unitName}', style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${LocaleKeys.maintenanceEstimatedCost.tr()}: ${request.estimatedCost} ${LocaleKeys.commonCurrencySar.tr()}',
                      style: TextStyle(color: context.primaryColor, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      request.requestedDate ?? '',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
