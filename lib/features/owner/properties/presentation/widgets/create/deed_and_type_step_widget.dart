import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../cubit/create/property_create_cubit.dart';
import '../../cubit/create/property_create_state.dart';

class DeedAndTypeStepWidget extends StatelessWidget {
  const DeedAndTypeStepWidget({super.key});

  IconData _getIconForType(String value) {
    switch (value) {
      case 'villa':
        return Icons.villa_rounded;
      case 'building':
        return Icons.apartment_rounded;
      case 'complex':
        return Icons.domain_rounded;
      case 'mall':
        return Icons.shopping_bag_rounded;
      case 'land':
        return Icons.landscape_rounded;
      default:
        return Icons.business_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyCreateCubit, PropertyCreateState>(
      builder: (context, state) {
        final cubit = context.read<PropertyCreateCubit>();
        final options = state.formData?.options;
        final deedsList = options?.deeds ?? [];
        final typesList = options?.propertyTypes ?? [];
        final branchesList = options?.branches ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.propertyCreateStep1Title.tr(),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                LocaleKeys.propertyCreateStep1Subtitle.tr(),
                style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondaryLight),
              ),
              const SizedBox(height: 20),

              // Branch Selector if branches exist
              if (branchesList.isNotEmpty) ...[
                DropdownButtonFormField<int>(
                  initialValue: state.selectedBranchId ?? (branchesList.first.id),
                  decoration: InputDecoration(
                    labelText: 'الفرع',
                    border: OutlineInputBorder(borderRadius: AppRadius.circularLg),
                  ),
                  items: branchesList.map((b) {
                    return DropdownMenuItem<int>(
                      value: b.id,
                      child: Text(b.name),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) cubit.selectBranch(val);
                  },
                ),
                const SizedBox(height: 20),
              ],

              _buildSectionTitle(LocaleKeys.propertyCreateSelectDeed.tr()),
              const SizedBox(height: 10),
              if (deedsList.isEmpty && state.deeds.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: AppRadius.circularLg,
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.warning),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          LocaleKeys.propertyCreateNoDeed.tr(),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: deedsList.map((deed) {
                    final isSelected = state.selectedDeedId == deed.id;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? context.primarySubtle : AppColors.surfaceLight,
                        borderRadius: AppRadius.circularLg,
                        border: Border.all(
                          color: isSelected ? context.primaryColor : const Color(0xFFE2E8F0),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: ListTile(
                        onTap: () => cubit.selectDeed(deed.id),
                        leading: Icon(
                          Icons.description_outlined,
                          color: isSelected ? context.primaryColor : AppColors.textSecondaryLight,
                        ),
                        title: Text(
                          '${deed.code} - ${deed.name}',
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 13.5,
                          ),
                        ),
                        subtitle: Text(
                          'المستند: ${deed.documentNumber ?? "إلكتروني"} | الوحدات: ${deed.propertiesCount}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check_circle_rounded, color: context.primaryColor)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 24),
              const Divider(height: 1),
              const SizedBox(height: 20),
              _buildSectionTitle(LocaleKeys.propertyCreateSelectType.tr()),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: typesList.length,
                itemBuilder: (context, index) {
                  final item = typesList[index];
                  final isSelected = state.selectedType == item.value;

                  return Container(
                    decoration: BoxDecoration(
                      color: isSelected ? context.primarySubtle : AppColors.surfaceLight,
                      borderRadius: AppRadius.circularLg,
                      border: Border.all(
                        color: isSelected ? context.primaryColor : const Color(0xFFE2E8F0),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: InkWell(
                      onTap: () => cubit.selectType(item.value),
                      borderRadius: AppRadius.circularLg,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Icon(
                              _getIconForType(item.value),
                              color: isSelected ? context.primaryColor : AppColors.textSecondaryLight,
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.label,
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  fontSize: 13,
                                  color: isSelected ? context.primaryColor : AppColors.textPrimaryLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimaryLight,
      ),
    );
  }
}
