import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/custom_dropdown_menu.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../core/utils/widgets/custom_button.dart';
import '../../../../../core/utils/widgets/custom_text_field.dart';
import '../../domain/entities/supervisor_form_data_entity.dart';
import '../cubit/form_data/supervisor_form_data_cubit.dart';
import '../cubit/form_data/supervisor_form_data_state.dart';
import '../cubit/create/create_supervisor_cubit.dart';
import '../cubit/create/create_supervisor_state.dart';

class AddSupervisorBottomSheet extends StatelessWidget {
  const AddSupervisorBottomSheet({super.key});

  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => sl<SupervisorFormDataCubit>()..getFormData(),
          ),
          BlocProvider(create: (_) => sl<CreateSupervisorCubit>()),
        ],
        child: const AddSupervisorBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.sm),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Text(
                  LocaleKeys.addSupervisor.tr(),
                  style: AppTextStyles.h3,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              BlocConsumer<SupervisorFormDataCubit, SupervisorFormDataState>(
                listener: (context, state) {
                  if (state is SupervisorFormDataError) {
                    AppToast.showError(context, state.message);
                  }
                },
                builder: (context, state) {
                  if (state is SupervisorFormDataLoading ||
                      state is SupervisorFormDataInitial) {
                    return const _SupervisorFormSkeleton();
                  }

                  if (state is SupervisorFormDataError) {
                    return Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            state.message,
                            style: AppTextStyles.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          CustomButton(
                            text: LocaleKeys.retry.tr(),
                            onPressed: () {
                              context
                                  .read<SupervisorFormDataCubit>()
                                  .getFormData();
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is SupervisorFormDataSuccess) {
                    return _SupervisorForm(data: state.data);
                  }

                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SupervisorForm extends StatefulWidget {
  final SupervisorFormDataEntity data;

  const _SupervisorForm({required this.data});

  @override
  State<_SupervisorForm> createState() => _SupervisorFormState();
}

class _SupervisorFormState extends State<_SupervisorForm> {
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

      final body = <String, dynamic>{
        'user_id': _selectedUser!.id,
        'scope_type': _selectedScopeType!.value,
        'is_active': _isActive,
      };

      if (_selectedScopeValue != null) {
        body['scope_values'] = [_selectedScopeValue!.id];
      }

      final sortOrderText = _sortOrderController.text.trim();
      if (sortOrderText.isNotEmpty) {
        body['sort_order'] = int.tryParse(sortOrderText) ?? 0;
      }

      context.read<CreateSupervisorCubit>().createSupervisor(body);
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
                  ); // or a success string from API/locale
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

class _SupervisorFormSkeleton extends StatelessWidget {
  const _SupervisorFormSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppShimmer.box(
            width: double.infinity,
            height: 50,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          const SizedBox(height: AppSpacing.md),
          AppShimmer.box(
            width: double.infinity,
            height: 50,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          const SizedBox(height: AppSpacing.md),
          AppShimmer.box(
            width: double.infinity,
            height: 50,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppShimmer.box(
            width: double.infinity,
            height: 50,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ],
      ),
    );
  }
}
