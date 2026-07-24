import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../cubit/create/property_create_cubit.dart';
import '../../cubit/create/property_create_state.dart';

class Step5ReviewView extends StatelessWidget {
  const Step5ReviewView({super.key});

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
                LocaleKeys.propertyWizardStep5Title.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'راجع بيانات العقار قبل النشر النهائي',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 24),
              _buildSection(
                context,
                title: LocaleKeys.propertyWizardStep1Title.tr(),
                icon: Icons.info_outline,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRow('الفرع', state.formData?.options.branches.where((b) => b.id == state.selectedBranchId).firstOrNull?.name ?? ''),
                    _buildRow('الصك', state.formData?.options.deeds.where((d) => d.id == state.selectedDeedId).firstOrNull?.documentNumber ?? ''),
                    _buildRow('النوع', state.selectedType ?? ''),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildSection(
                context,
                title: LocaleKeys.propertyWizardStep2Title.tr(),
                icon: Icons.description_outlined,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRow('اسم العقار', state.name ?? ''),
                    _buildRow('العنوان', state.address ?? ''),
                    _buildRow('المساحة', '${state.area ?? 0} م²'),
                    _buildRow('سنة البناء', state.constructionYear?.toString() ?? ''),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildSection(
                context,
                title: LocaleKeys.propertyWizardStep3Title.tr(),
                icon: Icons.photo_library_outlined,
                content: state.images.isEmpty
                    ? const Text('لم يتم إضافة صور', style: TextStyle(color: AppColors.textSecondaryLight))
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: state.images.map((img) {
                          return Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: AppRadius.circularSm,
                              image: DecorationImage(
                                image: FileImage(File(img.localPath)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
              ),
              const SizedBox(height: 16),
              _buildSection(
                context,
                title: LocaleKeys.propertyWizardStep4Title.tr(),
                icon: Icons.people_outline,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: state.owners.map((o) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(o.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                          Text('${o.percentage}%', style: TextStyle(color: context.primaryColor, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required IconData icon, required Widget content}) {
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
              Icon(icon, size: 20, color: context.primaryColor),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13)),
          ),
          Expanded(
            child: Text(value.isEmpty ? '-' : value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
