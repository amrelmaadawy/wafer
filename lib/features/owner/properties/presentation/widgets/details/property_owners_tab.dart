import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/property_details_entity.dart';

class PropertyOwnersTab extends StatelessWidget {
  final PropertyDetailsEntity property;

  const PropertyOwnersTab({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('الملاك', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          if (property.owners.isEmpty)
            const Center(child: Text('لا يوجد ملاك مسجلين'))
          else
            ...property.owners.map((owner) => Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: context.primarySubtle,
                  child: Icon(Icons.person, color: context.primaryColor),
                ),
                title: Text(owner.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(owner.phone ?? 'لا يوجد رقم هاتف'),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${owner.percentage}%',
                    style: TextStyle(color: context.primaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )),
            
          const SizedBox(height: 24),
          const Text('معلومات الصك والوثائق', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildDocRow('رقم الصك', property.deedNumber ?? 'غير متوفر'),
                  const Divider(),
                  _buildDocRow('تاريخ الصك', property.deedDate ?? 'غير متوفر'),
                  const Divider(),
                  _buildDocRow('نوع الوثيقة', property.documentType ?? 'غير متوفر'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
