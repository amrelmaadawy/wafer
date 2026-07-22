import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../cubit/create/property_create_cubit.dart';
import '../../cubit/create/property_create_state.dart';

class OwnersAndImagesStepWidget extends StatefulWidget {
  const OwnersAndImagesStepWidget({super.key});

  @override
  State<OwnersAndImagesStepWidget> createState() => _OwnersAndImagesStepWidgetState();
}

class _OwnersAndImagesStepWidgetState extends State<OwnersAndImagesStepWidget> {
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _ownerShareController = TextEditingController();

  @override
  void dispose() {
    _ownerNameController.dispose();
    _ownerShareController.dispose();
    super.dispose();
  }

  void _onAddOwner(BuildContext context) {
    final name = _ownerNameController.text.trim();
    final share = num.tryParse(_ownerShareController.text);
    if (name.isNotEmpty && share != null && share > 0) {
      context.read<PropertyCreateCubit>().addOwner(name, share);
      _ownerNameController.clear();
      _ownerShareController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyCreateCubit, PropertyCreateState>(
      builder: (context, state) {
        final cubit = context.read<PropertyCreateCubit>();
        final optionsOwners = state.formData?.options.owners ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.propertyCreateStep3Title.tr(),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              _buildProgressBar(context, state),
              const SizedBox(height: 16),

              if (optionsOwners.isNotEmpty) ...[
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'اختر مالك من القائمة',
                    border: OutlineInputBorder(borderRadius: AppRadius.circularLg),
                  ),
                  items: optionsOwners.map((o) => DropdownMenuItem(value: o.id, child: Text('${o.name} (${o.phone ?? o.identityNumber ?? ""})'))).toList(),
                  onChanged: (id) {
                    if (id != null) {
                      final selected = optionsOwners.firstWhere((element) => element.id == id);
                      _ownerNameController.text = selected.name;
                    }
                  },
                ),
                const SizedBox(height: 12),
              ],

              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: _ownerNameController,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.propertyCreateOwnerName.tr(),
                        border: OutlineInputBorder(borderRadius: AppRadius.circularLg),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _ownerShareController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'النسبة %',
                        border: OutlineInputBorder(borderRadius: AppRadius.circularLg),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () => _onAddOwner(context),
                    icon: const Icon(Icons.add_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: context.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.circularLg),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                children: List.generate(state.owners.length, (index) {
                  final owner = state.owners[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: AppRadius.circularLg,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(owner.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                        Row(
                          children: [
                            Text('${owner.percentage}%', style: TextStyle(color: context.primaryColor, fontWeight: FontWeight.w700)),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
                              onPressed: () => cubit.removeOwner(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              const Divider(height: 1),
              const SizedBox(height: 20),
              Text(
                LocaleKeys.propertyCreateAddImage.tr(),
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: AppRadius.circularXl,
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: Column(
                  children: [
                    Icon(Icons.cloud_upload_outlined, size: 40, color: context.primaryColor),
                    const SizedBox(height: 8),
                    const Text('اضغط لرفع صور العقار أو المرفقات', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressBar(BuildContext context, PropertyCreateState state) {
    final total = state.totalOwnersPercentage;
    final isValid = state.isOwnersPercentageValid;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isValid ? AppColors.success.withValues(alpha: 0.1) : AppColors.warning.withValues(alpha: 0.1),
        borderRadius: AppRadius.circularLg,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${LocaleKeys.propertyCreatePercentageTotal.tr()}: $total%',
                style: TextStyle(color: isValid ? AppColors.success : AppColors.warning, fontWeight: FontWeight.w700, fontSize: 13),
              ),
              if (!isValid)
                Text(LocaleKeys.propertyCreatePercentageError.tr(), style: const TextStyle(color: AppColors.error, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: AppRadius.circularFull,
            child: LinearProgressIndicator(
              value: (total / 100).clamp(0.0, 1.0),
              backgroundColor: Colors.white,
              color: isValid ? AppColors.success : AppColors.warning,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
