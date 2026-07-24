import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_dropdown_menu.dart';
import '../../../../../core/routing/routes.dart';
import '../../domain/entities/form_branch_entity.dart';
import '../cubit/create/property_create_cubit.dart';
import '../cubit/create/property_create_state.dart';
import '../widgets/create/deed_selector_widget.dart';
import '../widgets/create/property_type_selector_widget.dart';
import '../../../../../core/utils/widgets/app_toast.dart';

class PropertyCreateScreen extends StatefulWidget {
  const PropertyCreateScreen({super.key});

  @override
  State<PropertyCreateScreen> createState() => _PropertyCreateScreenState();
}

class _PropertyCreateScreenState extends State<PropertyCreateScreen> {
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    context.read<PropertyCreateCubit>().loadFormOptions();
  }

  void _onSubmit(PropertyCreateState state) async {
    setState(() => _submitted = true);
    final cubit = context.read<PropertyCreateCubit>();

    if (state.selectedBranchId == null ||
        state.selectedDeedId == null ||
        state.selectedType == null) {
      if (!mounted) return;
      AppToast.showError(context, 'يرجى إكمال جميع الحقول المطلوبة');
      return;
    }

    final success = await cubit.createDraft();
    if (success && mounted) {
      AppToast.showSuccess(context, LocaleKeys.propertyCreateSuccess.tr());
      // Navigate to Property Details Dashboard
      context.pushReplacement(
        '${Routes.ownerPropertyDetails}?id=${cubit.state.draftPropertyId}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(
        title: LocaleKeys.propertyCreateTitle.tr(),
      ),
      body: BlocConsumer<PropertyCreateCubit, PropertyCreateState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            AppToast.showError(context, state.errorMessage!);
          }
        },
        builder: (context, state) {
          if (state.isLoading || state.formData == null) {
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

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
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
                          errorText: _submitted && state.selectedBranchId == null
                              ? LocaleKeys.propertyCreateSelectBranchRequired.tr()
                              : null,
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
                        errorText: _submitted && state.selectedDeedId == null
                            ? LocaleKeys.propertyCreateSelectDeedRequired.tr()
                            : null,
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
                        errorText: _submitted && state.selectedType == null
                            ? LocaleKeys.propertyCreateSelectTypeRequired.tr()
                            : null,
                      ),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              _buildBottomNav(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, PropertyCreateState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: state.isSaving ? null : () => _onSubmit(state),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.circularLg),
            ),
            child: state.isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Text(
                    LocaleKeys.propertyCreateSubmit.tr(),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
          ),
        ),
      ),
    );
  }
}
