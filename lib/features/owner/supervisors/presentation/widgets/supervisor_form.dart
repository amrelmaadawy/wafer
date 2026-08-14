import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/custom_dropdown_menu.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../core/utils/widgets/custom_button.dart';
import '../../../../../core/utils/widgets/custom_text_field.dart';
import '../../domain/entities/create_maintenance_supervisor_params.dart';
import '../../domain/entities/supervisor_form_data_entity.dart';
import '../cubit/create/create_supervisor_cubit.dart';
import '../cubit/create/create_supervisor_state.dart';

class SupervisorForm extends StatefulWidget {
  final SupervisorFormDataEntity data;

  const SupervisorForm({super.key, required this.data});

  @override
  State<SupervisorForm> createState() => _SupervisorFormState();
}

class _SupervisorFormState extends State<SupervisorForm> {
  final _formKey = GlobalKey<FormState>();
  final _sortOrderController = TextEditingController();

  SupervisorUserEntity? _selectedUser;
  SupervisorScopeTypeEntity? _selectedScopeType;
  SupervisorScopeValueEntity? _selectedScopeValue;
  SupervisorScopeConditionEntity? _selectedCondition;
  bool _isActive = true;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _initDefaults();
  }

  void _initDefaults() {
    final defaults = widget.data.defaults;
    _isActive = defaults.isActive ?? true;

    if (defaults.sortOrder != null) {
      _sortOrderController.text = defaults.sortOrder.toString();
    }

    if (defaults.scopeType != null) {
      final index = widget.data.scopeTypes.indexWhere(
        (e) => e.value == defaults.scopeType,
      );
      _selectedScopeType = index != -1
          ? widget.data.scopeTypes[index]
          : (widget.data.scopeTypes.isNotEmpty
                ? widget.data.scopeTypes.first
                : null);
    } else if (widget.data.scopeTypes.isNotEmpty) {
      _selectedScopeType = widget.data.scopeTypes.first;
    }

    if (defaults.scopeCondition != null) {
      final index = widget.data.scopeConditions.indexWhere(
        (e) => e.value == defaults.scopeCondition,
      );
      _selectedCondition = index != -1
          ? widget.data.scopeConditions[index]
          : (widget.data.scopeConditions.isNotEmpty
                ? widget.data.scopeConditions.first
                : null);
    } else if (widget.data.scopeConditions.isNotEmpty) {
      _selectedCondition = widget.data.scopeConditions.first;
    }

    _updateScopeValueFromDefaults(defaults);
  }

  void _updateScopeValueFromDefaults(SupervisorFormDefaultsEntity defaults) {
    if (_selectedScopeType != null &&
        widget.data.scopeValues.containsKey(_selectedScopeType!.value)) {
      final availableValues =
          widget.data.scopeValues[_selectedScopeType!.value]!;

      if (defaults.scopeValues != null && defaults.scopeValues!.isNotEmpty) {
        final defaultValueId = defaults.scopeValues!.first;
        final index = availableValues.indexWhere((e) => e.id == defaultValueId);
        _selectedScopeValue = index != -1
            ? availableValues[index]
            : (availableValues.isNotEmpty ? availableValues.first : null);
      }
    }
  }

  @override
  void dispose() {
    _sortOrderController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() {
      _isSubmitted = true;
    });

    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedUser == null || _selectedScopeType == null) return;

      final availableScopeValues = _getAvailableScopeValues();
      final requiresScopeValue = widget.data.validation.scopeTypeRequiresValues
          .contains(_selectedScopeType?.value);

      if (requiresScopeValue &&
          availableScopeValues.isNotEmpty &&
          _selectedScopeValue == null) {
        return;
      }

      final params = CreateMaintenanceSupervisorParams(
        userId: _selectedUser!.id,
        scopeType: _selectedScopeType!.value,
        isActive: _isActive,
        scopeValues: _selectedScopeValue != null ? [_selectedScopeValue!.id] : null,
        sortOrder: _sortOrderController.text.trim().isNotEmpty 
            ? int.tryParse(_sortOrderController.text.trim()) 
            : null,
      );

      context.read<CreateSupervisorCubit>().createSupervisor(params);
    }
  }

  List<SupervisorScopeValueEntity> _getAvailableScopeValues() {
    if (_selectedScopeType == null) return [];
    return widget.data.scopeValues[_selectedScopeType!.value] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final availableScopeValues = _getAvailableScopeValues();
    final requiresScopeValue = widget.data.validation.scopeTypeRequiresValues
        .contains(_selectedScopeType?.value);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomDropdownMenu<SupervisorUserEntity>(
              hint: LocaleKeys.supervisorSelectUser.tr(),
              value: _selectedUser,
              items: widget.data.users,
              itemLabelBuilder: (user) => user.name ?? user.phone ?? '',
              onSelected: (user) {
                setState(() {
                  _selectedUser = user;
                });
              },
              errorText: _isSubmitted && _selectedUser == null
                  ? LocaleKeys.maintenanceRequiredField.tr()
                  : null,
            ),
            const SizedBox(height: AppSpacing.md),
            CustomDropdownMenu<SupervisorScopeTypeEntity>(
              hint: LocaleKeys.supervisorScopeType.tr(),
              value: _selectedScopeType,
              items: widget.data.scopeTypes,
              itemLabelBuilder: (type) => type.label,
              onSelected: (type) {
                setState(() {
                  _selectedScopeType = type;
                  _selectedScopeValue = null;
                });
              },
              errorText: _isSubmitted && _selectedScopeType == null
                  ? LocaleKeys.maintenanceRequiredField.tr()
                  : null,
            ),
            if (requiresScopeValue && availableScopeValues.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              CustomDropdownMenu<SupervisorScopeValueEntity>(
                hint: LocaleKeys.supervisorScopeValue.tr(),
                value: _selectedScopeValue,
                items: availableScopeValues,
                itemLabelBuilder: (val) =>
                    val.name ?? val.code ?? val.id.toString(),
                onSelected: (val) {
                  setState(() {
                    _selectedScopeValue = val;
                  });
                },
                errorText: _isSubmitted && _selectedScopeValue == null
                    ? LocaleKeys.maintenanceRequiredField.tr()
                    : null,
              ),
            ],
            if (widget.data.scopeConditions.length > 1) ...[
              const SizedBox(height: AppSpacing.md),
              CustomDropdownMenu<SupervisorScopeConditionEntity>(
                hint: LocaleKeys.supervisorCondition.tr(),
                value: _selectedCondition,
                items: widget.data.scopeConditions,
                itemLabelBuilder: (cond) => cond.label,
                onSelected: (cond) {
                  setState(() {
                    _selectedCondition = cond;
                  });
                },
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            CustomTextField(
              controller: _sortOrderController,
              label: LocaleKeys.supervisorSortOrder.tr(),
              hintText: '0',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.supervisorIsActive.tr(),
                  style: AppTextStyles.bodyMedium,
                ),
                CupertinoSwitch(
                  value: _isActive,
                  activeTrackColor: context.primaryColor,
                  onChanged: (val) {
                    setState(() {
                      _isActive = val;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            BlocConsumer<CreateSupervisorCubit, CreateSupervisorState>(
              listener: (context, state) {
                if (state is CreateSupervisorSuccess) {
                  AppToast.showSuccess(
                    context,
                    LocaleKeys.addSupervisor.tr(),
                  );
                  Navigator.pop(context, true);
                } else if (state is CreateSupervisorError) {
                  AppToast.showError(context, state.message);
                }
              },
              builder: (context, state) {
                return CustomButton(
                  text: LocaleKeys.saveSupervisor.tr(),
                  onPressed: state is CreateSupervisorLoading ? () {} : _submit,
                  isLoading: state is CreateSupervisorLoading,
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
