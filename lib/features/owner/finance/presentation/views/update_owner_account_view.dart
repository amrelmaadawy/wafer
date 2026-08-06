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
import '../../../../../generated/locale_keys.dart';
import '../../domain/entities/finance_account_entity.dart';
import '../cubit/accounts/update_finance_account_cubit.dart';
import '../cubit/accounts/update_finance_account_state.dart';

class UpdateOwnerAccountView extends StatefulWidget {
  final FinanceAccountEntity account;

  const UpdateOwnerAccountView({super.key, required this.account});

  @override
  State<UpdateOwnerAccountView> createState() => _UpdateOwnerAccountViewState();
}

class _UpdateOwnerAccountViewState extends State<UpdateOwnerAccountView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameArController;
  late final TextEditingController _nameEnController;
  late final TextEditingController _codeController;
  late final TextEditingController _descController;

  late String _selectedType;
  late bool _isPostable;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.account.code);
    _nameArController = TextEditingController(text: widget.account.nameAr);
    _nameEnController = TextEditingController(text: widget.account.nameEn);
    _descController = TextEditingController(text: widget.account.descriptionAr);
    _selectedType = widget.account.type;
    _isPostable = widget.account.isPostable;
    _isActive = widget.account.isActive;
  }

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
      context.read<UpdateFinanceAccountCubit>().updateAccount(
            id: widget.account.id,
            code: _codeController.text,
            nameAr: _nameArController.text,
            nameEn: _nameEnController.text,
            type: _selectedType,
            isPostable: _isPostable,
            isActive: _isActive,
            descriptionAr: _descController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateFinanceAccountCubit, UpdateFinanceAccountState>(
      listener: (context, state) {
        if (state is UpdateFinanceAccountSuccess) {
          AppToast.showSuccess(context, state.message);
          context.pop(true); // Return true to indicate success and trigger refresh
        } else if (state is UpdateFinanceAccountError) {
          AppToast.showError(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          leadingWidth: 68,
          leading: const CustomBackButton(),
          title: Text(LocaleKeys.owner_finance_update_account.tr()),
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
              CustomDropdownMenu<String>(
                hint: LocaleKeys.owner_finance_account_type.tr(),
                value: _selectedType,
                items: const ['asset', 'liability', 'expense', 'revenue', 'equity'],
                itemLabelBuilder: (item) {
                  switch (item) {
                    case 'asset':
                      return LocaleKeys.owner_finance_account_type_asset.tr();
                    case 'liability':
                      return LocaleKeys.owner_finance_account_type_liability.tr();
                    case 'expense':
                      return LocaleKeys.owner_finance_account_type_expense.tr();
                    case 'revenue':
                      return LocaleKeys.owner_finance_account_type_revenue.tr();
                    case 'equity':
                      return LocaleKeys.owner_finance_account_type_equity.tr();
                    default:
                      return item;
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
              BlocBuilder<UpdateFinanceAccountCubit, UpdateFinanceAccountState>(
                builder: (context, state) {
                  return CustomButton(
                    onPressed: state is UpdateFinanceAccountLoading ? () {} : _submit,
                    text: LocaleKeys.owner_finance_account_update_submit.tr(),
                    isLoading: state is UpdateFinanceAccountLoading,
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
