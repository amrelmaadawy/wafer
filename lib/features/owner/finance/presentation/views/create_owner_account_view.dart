import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/presentation/widgets/custom_back_button.dart';
import '../../../../../core/utils/widgets/custom_button.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/presentation/widgets/custom_dropdown_menu.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../domain/entities/finance_account_type.dart';
import '../cubit/accounts/create_finance_account_cubit.dart';
import '../cubit/accounts/create_finance_account_state.dart';

class CreateOwnerAccountView extends StatefulWidget {
  const CreateOwnerAccountView({super.key});

  @override
  State<CreateOwnerAccountView> createState() => _CreateOwnerAccountViewState();
}

class _CreateOwnerAccountViewState extends State<CreateOwnerAccountView> {
  final _formKey = GlobalKey<FormState>();
  final _nameArController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _codeController = TextEditingController();
  final _descController = TextEditingController();

  FinanceAccountType _selectedType = FinanceAccountType.asset;
  bool _isPostable = true;
  bool _isActive = true;

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    _codeController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<CreateFinanceAccountCubit>().createAccount(
            code: _codeController.text,
            nameAr: _nameArController.text,
            nameEn: _nameEnController.text,
            type: _selectedType.value,
            isPostable: _isPostable,
            isActive: _isActive,
            descriptionAr: _descController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateFinanceAccountCubit, CreateFinanceAccountState>(
      listener: (context, state) {
        if (state is CreateFinanceAccountSuccess) {
          AppToast.showSuccess(context, state.message);
          context.pop(true);
        } else if (state is CreateFinanceAccountError) {
          AppToast.showError(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          leadingWidth: 68,
          leading: const CustomBackButton(),
          title: Text(LocaleKeys.owner_finance_create_account.tr()),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              CustomTextField(
                controller: _codeController,
                label: LocaleKeys.owner_finance_account_code.tr(),
                hintText: LocaleKeys.owner_finance_account_code.tr(),
                validator: (value) => value == null || value.isEmpty ? LocaleKeys.required_field.tr() : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _nameArController,
                label: LocaleKeys.owner_finance_account_name_ar.tr(),
                hintText: LocaleKeys.owner_finance_account_name_ar.tr(),
                validator: (value) => value == null || value.isEmpty ? LocaleKeys.required_field.tr() : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _nameEnController,
                label: LocaleKeys.owner_finance_account_name_en.tr(),
                hintText: LocaleKeys.owner_finance_account_name_en.tr(),
                validator: (value) => value == null || value.isEmpty ? LocaleKeys.required_field.tr() : null,
              ),
              const SizedBox(height: 16),
              CustomDropdownMenu<FinanceAccountType>(
                hint: LocaleKeys.owner_finance_account_type.tr(),
                value: _selectedType,
                items: FinanceAccountType.values.where((e) => e != FinanceAccountType.unknown).toList(),
                itemLabelBuilder: (item) {
                  switch (item) {
                    case FinanceAccountType.asset:
                      return LocaleKeys.owner_finance_account_type_asset.tr();
                    case FinanceAccountType.liability:
                      return LocaleKeys.owner_finance_account_type_liability.tr();
                    case FinanceAccountType.expense:
                      return LocaleKeys.owner_finance_account_type_expense.tr();
                    case FinanceAccountType.revenue:
                      return LocaleKeys.owner_finance_account_type_revenue.tr();
                    case FinanceAccountType.equity:
                      return LocaleKeys.owner_finance_account_type_equity.tr();
                    default:
                      return item.value;
                  }
                },
                onSelected: (value) {
                  setState(() => _selectedType = value);
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descController,
                label: LocaleKeys.owner_finance_account_desc.tr(),
                hintText: LocaleKeys.owner_finance_account_desc.tr(),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              _buildSwitchRow(
                title: LocaleKeys.owner_finance_postable.tr(),
                value: _isPostable,
                onChanged: (val) => setState(() => _isPostable = val),
              ),
              const SizedBox(height: 16),
              _buildSwitchRow(
                title: LocaleKeys.owner_finance_account_is_active.tr(),
                value: _isActive,
                onChanged: (val) => setState(() => _isActive = val),
              ),
              const SizedBox(height: 32),
              BlocBuilder<CreateFinanceAccountCubit, CreateFinanceAccountState>(
                builder: (context, state) {
                  return CustomButton(
                    onPressed: state is CreateFinanceAccountLoading ? () {} : _submit,
                    text: LocaleKeys.owner_finance_account_submit.tr(),
                    isLoading: state is CreateFinanceAccountLoading,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularMd,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: context.primaryColor,
          ),
        ],
      ),
    );
  }
}