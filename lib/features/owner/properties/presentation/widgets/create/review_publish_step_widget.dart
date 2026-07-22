import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../cubit/create/property_create_cubit.dart';
import '../../cubit/create/property_create_state.dart';

class ReviewPublishStepWidget extends StatelessWidget {
  const ReviewPublishStepWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyCreateCubit, PropertyCreateState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.propertyCreateStep4Title.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 16),
              _buildSummaryCard(
                context,
                title: 'الصك والنوع',
                icon: Icons.description_outlined,
                children: [
                  _buildRow('النوع:', state.selectedType ?? '-'),
                  _buildRow('رقم الصك:', '${state.selectedDeedId ?? '-'}'),
                ],
              ),
              const SizedBox(height: 12),
              _buildSummaryCard(
                context,
                title: 'البيانات الأساسية',
                icon: Icons.info_outline_rounded,
                children: [
                  _buildRow('اسم العقار:', state.propertyName),
                  if (state.address.isNotEmpty) _buildRow('العنوان:', state.address),
                  if (state.area != null) _buildRow('المساحة:', '${state.area} م²'),
                ],
              ),
              const SizedBox(height: 12),
              _buildSummaryCard(
                context,
                title: 'الملاك',
                icon: Icons.people_outline_rounded,
                children: state.owners
                    .map((o) => _buildRow('${o.name}:', '${o.percentage}%'))
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularXl,
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: context.primaryColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondaryLight, fontSize: 13)),
          Text(value,
              style: const TextStyle(
                  color: AppColors.textPrimaryLight,
                  fontWeight: FontWeight.w600,
                  fontSize: 13)),
        ],
      ),
    );
  }
}
