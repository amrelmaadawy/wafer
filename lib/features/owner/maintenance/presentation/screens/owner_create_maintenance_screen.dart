import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wafer/core/utils/widgets/custom_text_field.dart';
import 'package:wafer/core/utils/widgets/custom_button.dart';
import 'package:wafer/core/di/service_locator.dart';
import 'package:wafer/core/presentation/widgets/custom_dropdown_menu.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/color_utils.dart';
import '../cubit/create_maintenance/owner_create_maintenance_cubit.dart';
import '../cubit/create_maintenance/owner_create_maintenance_state.dart';

class OwnerCreateMaintenanceScreen extends StatelessWidget {
  const OwnerCreateMaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OwnerCreateMaintenanceCubit>()..init(),
      child: const _OwnerCreateMaintenanceView(),
    );
  }
}

class _OwnerCreateMaintenanceView extends StatefulWidget {
  const _OwnerCreateMaintenanceView();

  @override
  State<_OwnerCreateMaintenanceView> createState() =>
      _OwnerCreateMaintenanceViewState();
}

class _OwnerCreateMaintenanceViewState
    extends State<_OwnerCreateMaintenanceView> {
  final _formKey = GlobalKey<FormState>();

  final List<String> _availableMaintenanceTypes = [
    'AC',
    'Electrical',
    'Plumbing',
    'Carpentry',
    'Painting',
    'Cleaning',
    'General',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          LocaleKeys.maintenanceTitle.tr(), // Use a generic title or add a specific one later
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: BlocConsumer<OwnerCreateMaintenanceCubit, OwnerCreateMaintenanceState>(
        listener: (context, state) {
          if (state.status == CreateMaintenanceStatus.success) {
            AppToast.showSuccess(context, LocaleKeys.maintenanceCreateSuccess.tr());
            Navigator.of(context).pop(true);
          } else if (state.status == CreateMaintenanceStatus.failure) {
            AppToast.showError(context, state.errorMessage ?? LocaleKeys.errorsServerError.tr());
          }
        },
        builder: (context, state) {
          return ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.md),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(LocaleKeys.maintenanceCreatePropertyUnitSection.tr()),
                  const SizedBox(height: AppSpacing.sm),
                  _buildPropertiesDropdown(state),
                  const SizedBox(height: AppSpacing.md),
                  if (state.selectedPropertyId != null) ...[
                    _buildUnitsDropdown(state),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  _buildSectionTitle(LocaleKeys.maintenanceCreateClientSection.tr()),
                  const SizedBox(height: AppSpacing.sm),
                  _buildClientFields(context, state),
                  const SizedBox(height: AppSpacing.md),
                  _buildSectionTitle(LocaleKeys.maintenanceCreateDetailsSection.tr()),
                  const SizedBox(height: AppSpacing.sm),
                  _buildRequestDetails(context, state),
                  const SizedBox(height: AppSpacing.xl),
                  CustomButton(
                    text: LocaleKeys.maintenanceCreateSubmit.tr(),
                    isLoading: state.status == CreateMaintenanceStatus.loading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (state.maintenanceTypes.isEmpty) {
                          AppToast.showError(context, LocaleKeys.maintenanceCreateFillAllFields.tr());
                          return;
                        }
                        context.read<OwnerCreateMaintenanceCubit>().submit();
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

  Widget _buildPropertiesDropdown(OwnerCreateMaintenanceState state) {
    if (state.isPropertiesLoading) {
      return const AppShimmer(
        child: SizedBox(
          height: 55,
          width: double.infinity,
          child: DecoratedBox(decoration: BoxDecoration(color: Colors.white, borderRadius: AppRadius.circularMd)),
        ),
      );
    }
    return FormField<int>(
      initialValue: state.selectedPropertyId,
      validator: (val) => val == null ? LocaleKeys.maintenanceCreateRequiredField.tr() : null,
      builder: (formFieldState) {
        return CustomDropdownMenu<int>(
          hint: LocaleKeys.maintenanceCreateSelectProperty.tr(),
          items: state.properties.map((p) => p.id).toList(),
          value: state.selectedPropertyId,
          itemLabelBuilder: (id) {
            final prop = state.properties.where((p) => p.id == id).firstOrNull;
            return prop?.name ?? '';
          },
          errorText: formFieldState.errorText,
          onSelected: (id) {
            formFieldState.didChange(id);
            context.read<OwnerCreateMaintenanceCubit>().loadUnits(id);
          },
        );
      },
    );
  }

  Widget _buildUnitsDropdown(OwnerCreateMaintenanceState state) {
    if (state.isUnitsLoading) {
      return const AppShimmer(
        child: SizedBox(
          height: 55,
          width: double.infinity,
          child: DecoratedBox(decoration: BoxDecoration(color: Colors.white, borderRadius: AppRadius.circularMd)),
        ),
      );
    }
    final List<int?> items = [null, ...state.units.map((u) => u.id)];

    return FormField<int?>(
      initialValue: state.selectedUnitId,
      builder: (formFieldState) {
        return CustomDropdownMenu<int?>(
          hint: LocaleKeys.maintenanceCreateSelectUnit.tr(),
          items: items,
          value: state.selectedUnitId,
          itemLabelBuilder: (id) {
            if (id == null) return LocaleKeys.maintenanceCreateNoUnit.tr();
            final unit = state.units.where((u) => u.id == id).firstOrNull;
            if (unit == null) return '';
            return '${unit.unitNumber} - ${unit.typeLabel ?? ""}';
          },
          errorText: formFieldState.errorText,
          onSelected: (id) {
            formFieldState.didChange(id);
            context.read<OwnerCreateMaintenanceCubit>().selectUnit(id);
          },
        );
      },
    );
  }

  Widget _buildClientFields(BuildContext context, OwnerCreateMaintenanceState state) {
    return Column(
      children: [
        CustomTextField(
          label: LocaleKeys.maintenanceCreateClientName.tr(),
          hintText: LocaleKeys.maintenanceCreateClientNameHint.tr(),
          initialValue: state.clientName,
          onChanged: (val) => context.read<OwnerCreateMaintenanceCubit>().updateClientName(val),
          validator: (val) => val == null || val.isEmpty ? LocaleKeys.maintenanceCreateRequiredField.tr() : null,
        ),
        const SizedBox(height: AppSpacing.md),
        CustomTextField(
          label: LocaleKeys.maintenanceCreateClientPhone.tr(),
          hintText: LocaleKeys.maintenanceCreateClientPhoneHint.tr(),
          initialValue: state.clientPhone,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (val) => context.read<OwnerCreateMaintenanceCubit>().updateClientPhone(val),
          validator: (val) {
            if (val == null || val.isEmpty) return LocaleKeys.maintenanceCreateRequiredField.tr();
            if (!RegExp(r'^[0-9]+$').hasMatch(val)) return 'يجب إدخال أرقام فقط'; // Consider localizing this
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRequestDetails(BuildContext context, OwnerCreateMaintenanceState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: LocaleKeys.maintenanceCreateDescription.tr(),
          hintText: LocaleKeys.maintenanceCreateDescriptionHint.tr(),
          initialValue: state.description,
          maxLines: 4,
          onChanged: (val) => context.read<OwnerCreateMaintenanceCubit>().updateDescription(val),
          validator: (val) => val == null || val.isEmpty ? LocaleKeys.maintenanceCreateRequiredField.tr() : null,
        ),
        const SizedBox(height: AppSpacing.md),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
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
            if (date != null && context.mounted) {
              final formattedDate = DateFormat('yyyy-MM-dd').format(date);
              context.read<OwnerCreateMaintenanceCubit>().updateRequestedDate(formattedDate);
            }
          },
          child: InputDecorator(
            decoration: _inputDecoration(LocaleKeys.maintenanceRequestedDate.tr()),
            child: Text(
              state.requestedDate.isNotEmpty ? state.requestedDate : LocaleKeys.maintenanceCreateSelectDate.tr(),
              style: TextStyle(
                color: state.requestedDate.isNotEmpty ? AppColors.textPrimaryLight : AppColors.textSecondaryLight,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildSectionTitle(LocaleKeys.maintenanceCreateTypesSection.tr()),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableMaintenanceTypes.map((type) {
            final isSelected = state.maintenanceTypes.contains(type);
            return ChoiceChip(
              label: Text(type),
              selected: isSelected,
              selectedColor: context.primaryColor.withValues(alpha: 0.2),
              labelStyle: TextStyle(
                color: isSelected ? context.primaryColor : AppColors.textSecondaryLight,
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
              onSelected: (_) => context.read<OwnerCreateMaintenanceCubit>().toggleMaintenanceType(type),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleKeys.maintenanceCreateIsPrivate.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimaryLight,
              ),
            ),
            CupertinoSwitch(
              value: state.isPrivate,
              onChanged: (val) => context.read<OwnerCreateMaintenanceCubit>().updateIsPrivate(val),
              activeTrackColor: context.primaryColor,
            ),
          ],
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: AppRadius.circularMd,
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.circularMd,
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
    );
  }
}
