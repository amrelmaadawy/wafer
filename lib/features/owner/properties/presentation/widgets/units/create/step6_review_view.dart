import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/color_utils.dart';
import '../../../cubit/units/unit_create_cubit.dart';
import '../../../cubit/units/unit_create_state.dart';

class Step6ReviewView extends StatelessWidget {
  const Step6ReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnitCreateCubit, UnitCreateState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'مراجعة وتأكيد',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'يرجى مراجعة بيانات الوحدة قبل التأكيد',
                style: TextStyle(color: AppColors.textSecondaryLight),
              ),
              const SizedBox(height: 24),

              _buildSection(
                context,
                title: 'البيانات الأساسية',
                icon: Icons.info_outline,
                children: [
                  _buildReviewItem('اسم الوحدة', state.name ?? 'غير محدد'),
                  _buildReviewItem(
                    'رقم الوحدة',
                    state.unitNumber ?? 'غير محدد',
                  ),
                  _buildReviewItem('نوع الوحدة', state.unitType),
                  _buildReviewItem('الغرض', state.purpose),
                  _buildReviewItem('التشطيب', state.finishingType),
                  _buildReviewItem('مفروشة', state.isFurnished ? 'نعم' : 'لا'),
                ],
              ),
              const SizedBox(height: 16),

              _buildSection(
                context,
                title: 'المواصفات',
                icon: Icons.square_foot,
                children: [
                  _buildReviewItem('المساحة', '${state.area ?? 0} م²'),
                  _buildReviewItem(
                    'الدور',
                    '${state.floorType} (${state.floorNumber ?? 0})',
                  ),
                  _buildReviewItem('غرف النوم', '${state.roomsCount ?? 0}'),
                  _buildReviewItem('الحمامات', '${state.bathroomsCount ?? 0}'),
                ],
              ),
              const SizedBox(height: 16),

              _buildSection(
                context,
                title: 'الموقع والمرافق',
                icon: Icons.location_on_outlined,
                children: [
                  _buildReviewItem('المدينة', state.city ?? 'غير محدد'),
                  _buildReviewItem('الحي', state.district ?? 'غير محدد'),
                  _buildReviewItem(
                    'المميزات',
                    state.amenities.isEmpty
                        ? 'لا يوجد'
                        : state.amenities.join('، '),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildSection(
                context,
                title: 'التفاصيل المالية',
                icon: Icons.attach_money,
                children: [
                  _buildReviewItem(
                    'الإيجار (شهري)',
                    '${state.annualRentMonthly ?? 0}',
                  ),
                  _buildReviewItem(
                    'الإيجار (دفعتين)',
                    '${state.annualRent2Payments ?? 0}',
                  ),
                  _buildReviewItem(
                    'الإيجار (4 دفعات)',
                    '${state.annualRent4Payments ?? 0}',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildSection(
                context,
                title: 'الصور',
                icon: Icons.image_outlined,
                children: [
                  _buildReviewItem(
                    'عدد الصور المرفقة',
                    '${state.images.length} صور',
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              border: const Border(
                bottom: BorderSide(color: AppColors.borderLight),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: context.primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: context.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondaryLight,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
