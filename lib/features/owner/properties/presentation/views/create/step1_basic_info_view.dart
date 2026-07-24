import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/presentation/widgets/custom_dropdown_menu.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../domain/entities/form_branch_entity.dart';
import '../../cubit/create/property_create_cubit.dart';
import '../../cubit/create/property_create_state.dart';
import '../../widgets/create/deed_selector_widget.dart';
import '../../widgets/create/property_type_selector_widget.dart';

class Step1BasicInfoView extends StatelessWidget {
  const Step1BasicInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyCreateCubit, PropertyCreateState>(
      builder: (context, state) {
        if (state.formData == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final branches = state.formData!.options.branches;
        final propertyTypes = state.formData!.options.propertyTypes;
        final cubit = context.read<PropertyCreateCubit>();

        // Pre-select branch if only one available
        if (branches.length == 1 && state.selectedBranchId == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            cubit.selectBranch(branches.first.id);
          });
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.propertyCreateSubtitle.tr(),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 24),
              
              // 1. Branch Selector
              if (branches.length > 1) ...[
                Text(
                  LocaleKeys.propertyCreateSelectBranch.tr(),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                CustomDropdownMenu<FormBranchEntity>(
                  items: branches,
                  value: branches.where((b) => b.id == state.selectedBranchId).firstOrNull,
                  hint: LocaleKeys.propertyCreateSelectBranch.tr(),
                  itemLabelBuilder: (b) => b.name,
                  onSelected: (b) => cubit.selectBranch(b.id),
                ),
                const SizedBox(height: 24),
              ],

              // 2. Deed Selector
              DeedSelectorWidget(
                deeds: state.deeds,
                selectedDeedId: state.selectedDeedId,
                onSelect: cubit.selectDeed,
                onCreateNew: () async {
                  final result = await context.push(Routes.ownerDeedsCreate);
                  if (result != null) {
                    cubit.addNewDeed(result);
                  }
                },
              ),
              const SizedBox(height: 24),

              // 3. Property Type Selector
              Text(
                LocaleKeys.propertyCreateSelectType.tr(),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              PropertyTypeSelectorWidget(
                propertyTypes: propertyTypes,
                selectedType: state.selectedType,
                onSelect: cubit.selectType,
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}
