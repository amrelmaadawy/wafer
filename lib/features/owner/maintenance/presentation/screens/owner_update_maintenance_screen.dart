import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wafer/core/utils/widgets/custom_text_field.dart';
import 'package:wafer/core/utils/widgets/custom_button.dart';
import 'package:wafer/core/di/service_locator.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../domain/entities/maintenance_item_entity.dart';
import '../cubit/update_maintenance/owner_update_maintenance_cubit.dart';
import '../cubit/update_maintenance/owner_update_maintenance_state.dart';

class OwnerUpdateMaintenanceScreen extends StatelessWidget {
  final MaintenanceItemEntity maintenanceItem;

  const OwnerUpdateMaintenanceScreen({
    super.key,
    required this.maintenanceItem,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OwnerUpdateMaintenanceCubit>()..init(),
      child: _OwnerUpdateMaintenanceView(maintenanceItem: maintenanceItem),
    );
  }
}

class _OwnerUpdateMaintenanceView extends StatefulWidget {
  final MaintenanceItemEntity maintenanceItem;

  const _OwnerUpdateMaintenanceView({required this.maintenanceItem});

  @override
  State<_OwnerUpdateMaintenanceView> createState() =>
      _OwnerUpdateMaintenanceViewState();
}

class _OwnerUpdateMaintenanceViewState
    extends State<_OwnerUpdateMaintenanceView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  late List<String> _selectedMaintenanceTypes;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(
      text: widget.maintenanceItem.description ?? '',
    );
    _dateController = TextEditingController(
      text:
          widget.maintenanceItem.dates?.scheduledDate ??
          widget.maintenanceItem.dates?.requestedDate ??
          '',
    );

    // Extract names of types that are already present
    _selectedMaintenanceTypes =
        widget.maintenanceItem.types
            ?.map((t) => t.name ?? '')
            .where((name) => name.isNotEmpty)
            .toList() ??
        [];
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimaryLight,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _toggleMaintenanceType(String type) {
    setState(() {
      if (_selectedMaintenanceTypes.contains(type)) {
        _selectedMaintenanceTypes.remove(type);
      } else {
        _selectedMaintenanceTypes.add(type);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(title: LocaleKeys.maintenanceEdit.tr()),
      body:
          BlocConsumer<
            OwnerUpdateMaintenanceCubit,
            OwnerUpdateMaintenanceState
          >(
            listener: (context, state) {
              if (state.status == UpdateMaintenanceStatus.success) {
                AppToast.showSuccess(context, state.successMessage ?? '');
                context.pop(true);
              } else if (state.status == UpdateMaintenanceStatus.offlineQueued) {
                AppToast.showInfo(context, state.successMessage ?? '');
                context.pop(true);
              } else if (state.status == UpdateMaintenanceStatus.failure) {
                AppToast.showError(context, state.errorMessage ?? '');
              }
            },
            builder: (context, state) {
              if (state.formDataError != null) {
                return CustomErrorWidget(
                  message: state.formDataError!,
                  onRetry: () =>
                      context.read<OwnerUpdateMaintenanceCubit>().init(),
                );
              }

              return ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(overscroll: false),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle(
                          LocaleKeys.maintenanceCreateDetailsSection.tr(),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        CustomTextField(
                          label: LocaleKeys.maintenanceCreateDescription.tr(),
                          hintText: LocaleKeys.maintenanceCreateDescriptionHint
                              .tr(),
                          controller: _descriptionController,
                          maxLines: 4,
                          validator: (val) => val == null || val.isEmpty
                              ? LocaleKeys.maintenanceCreateRequiredField.tr()
                              : null,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _buildSectionTitle(
                          LocaleKeys.maintenanceScheduledDate.tr(),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: CustomTextField(
                              label: LocaleKeys.maintenanceScheduledDate.tr(),
                              controller: _dateController,
                              readOnly: true,
                              suffixIcon: Icon(
                                Icons.calendar_today,
                                color: AppColors.textSecondaryLight,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _buildSectionTitle(
                          LocaleKeys.maintenanceCreateTypes.tr(),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _buildMaintenanceTypesChips(context, state),
                        const SizedBox(height: AppSpacing.xl),
                        CustomButton(
                          text: LocaleKeys.maintenanceUpdateRequest.tr(),
                          isLoading:
                              state.status == UpdateMaintenanceStatus.loading,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (_selectedMaintenanceTypes.isEmpty) {
                                AppToast.showError(
                                  context,
                                  LocaleKeys.maintenanceCreateFillAllFields
                                      .tr(),
                                );
                                return;
                              }

                              context
                                  .read<OwnerUpdateMaintenanceCubit>()
                                  .updateMaintenanceRequest(
                                    id: widget.maintenanceItem.safeId,
                                    description: _descriptionController.text,
                                    scheduledDate:
                                        _dateController.text.isNotEmpty
                                        ? _dateController.text
                                        : null,
                                    maintenanceTypes: _selectedMaintenanceTypes,
                                  );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimaryLight,
      ),
    );
  }

  Widget _buildMaintenanceTypesChips(
    BuildContext context,
    OwnerUpdateMaintenanceState state,
  ) {
    if (state.isFormDataLoading) {
      return const AppShimmer(
        child: SizedBox(
          height: 80,
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.circularMd,
            ),
          ),
        ),
      );
    }

    if (state.availableMaintenanceTypes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          LocaleKeys.maintenanceNoTitle.tr(),
          style: const TextStyle(
            color: AppColors.textSecondaryLight,
            fontSize: 14,
          ),
        ),
      );
    }

    final uniqueTypesMap = <String, dynamic>{};
    for (var typeObj in state.availableMaintenanceTypes) {
      final key = typeObj.name ?? typeObj.id?.toString() ?? '';
      if (key.isNotEmpty) {
        uniqueTypesMap[key] = typeObj;
      }
    }

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: uniqueTypesMap.values.map((typeObj) {
        final typeStr = typeObj.id?.toString() ?? '';
        final isSelected =
            _selectedMaintenanceTypes.contains(typeObj.name) ||
            _selectedMaintenanceTypes.contains(typeStr);
        return ChoiceChip(
          label: Text(typeObj.name ?? typeStr),
          selected: isSelected,
          selectedColor: context.primaryColor.withValues(alpha: 0.2),
          labelStyle: TextStyle(
            color: isSelected
                ? context.primaryColor
                : AppColors.textSecondaryLight,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            side: BorderSide(
              color: isSelected ? context.primaryColor : AppColors.borderLight,
            ),
          ),
          showCheckmark: false,
          onSelected: (_) => _toggleMaintenanceType(typeObj.name ?? typeStr),
        );
      }).toList(),
    );
  }
}
