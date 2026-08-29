import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:wafer/core/di/service_locator.dart';
import 'package:wafer/core/localization/locale_keys.dart';
import 'package:wafer/core/presentation/widgets/custom_app_bar.dart';
import 'package:wafer/core/theme/theme_context.dart';
import 'package:wafer/core/theme/app_fonts.dart';
import 'package:wafer/core/theme/app_spacing.dart';
import 'package:wafer/core/theme/color_utils.dart';
import 'package:wafer/core/utils/widgets/app_toast.dart';
import 'package:wafer/core/utils/widgets/custom_button.dart';
import 'package:wafer/core/utils/widgets/custom_text_field.dart';
import '../../domain/entities/suppliers/create_owner_supplier_params.dart';
import '../cubit/suppliers/create/owner_supplier_create_cubit.dart';
import '../cubit/suppliers/create/owner_supplier_create_state.dart';

class OwnerSupplierCreateView extends StatefulWidget {
  const OwnerSupplierCreateView({super.key});

  @override
  State<OwnerSupplierCreateView> createState() => _OwnerSupplierCreateViewState();
}

class _OwnerSupplierCreateViewState extends State<OwnerSupplierCreateView> {
  final _formKey = GlobalKey<FormState>();
  
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _taxController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _companyPhoneController = TextEditingController();
  final _addressController = TextEditingController();
  
  bool _isActive = true;

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _contactController.dispose();
    _taxController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyPhoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final params = CreateOwnerSupplierParams(
        supplierCode: _codeController.text.trim(),
        companyName: _nameController.text.trim(),
        contactPerson: _contactController.text.trim(),
        taxNumber: _taxController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        companyPhone: _companyPhoneController.text.trim(),
        address: _addressController.text.trim(),
        isActive: _isActive,
      );
      
      context.read<OwnerSupplierCreateCubit>().createSupplier(params);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OwnerSupplierCreateCubit>(),
      child: BlocConsumer<OwnerSupplierCreateCubit, OwnerSupplierCreateState>(
        listener: (context, state) {
          if (state is OwnerSupplierCreateSuccess) {
            AppToast.showSuccess(context, LocaleKeys.supplier_create_success.tr());
            context.pop(true); // Return true to indicate success
          } else if (state is OwnerSupplierCreateError) {
            AppToast.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is OwnerSupplierCreateLoading;
          final errors = (state is OwnerSupplierCreateError) ? state.validationErrors : null;

          return Scaffold(
            backgroundColor: context.appBackgroundColor,
            appBar: CustomAppBar(
              title: LocaleKeys.supplier_create_title.tr(),
              showBackButton: true,
            ),
            body: SafeArea(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    CustomTextField(
                      controller: _codeController,
                      label: LocaleKeys.supplier_code_label.tr(),
                      hintText: LocaleKeys.supplier_code_hint.tr(),
                      errorText: errors?['supplier_code']?.first,
                      prefixIcon: Icon(Icons.qr_code_rounded, color: context.primaryColor),
                      validator: (value) => value == null || value.trim().isEmpty ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    CustomTextField(
                      controller: _nameController,
                      label: LocaleKeys.supplier_company_name_label.tr(),
                      hintText: LocaleKeys.supplier_company_name_hint.tr(),
                      errorText: errors?['company_name']?.first,
                      prefixIcon: Icon(Icons.storefront_rounded, color: context.primaryColor),
                      validator: (value) => value == null || value.trim().isEmpty ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    CustomTextField(
                      controller: _contactController,
                      label: LocaleKeys.supplier_contact_person_label.tr(),
                      hintText: LocaleKeys.supplier_contact_person_hint.tr(),
                      errorText: errors?['contact_person']?.first,
                      prefixIcon: Icon(Icons.person_rounded, color: context.primaryColor),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    CustomTextField(
                      controller: _taxController,
                      label: LocaleKeys.supplier_tax_number_label.tr(),
                      hintText: LocaleKeys.supplier_tax_number_hint.tr(),
                      errorText: errors?['tax_number']?.first,
                      keyboardType: TextInputType.number,
                      prefixIcon: Icon(Icons.receipt_long_rounded, color: context.primaryColor),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    CustomTextField(
                      controller: _emailController,
                      label: LocaleKeys.supplier_email_label.tr(),
                      hintText: LocaleKeys.supplier_email_hint.tr(),
                      errorText: errors?['email']?.first,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(Icons.email_rounded, color: context.primaryColor),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    CustomTextField(
                      controller: _phoneController,
                      label: LocaleKeys.supplier_phone_label.tr(),
                      hintText: LocaleKeys.supplier_phone_hint.tr(),
                      errorText: errors?['phone']?.first,
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icon(Icons.phone_android_rounded, color: context.primaryColor),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    CustomTextField(
                      controller: _companyPhoneController,
                      label: LocaleKeys.supplier_company_phone_label.tr(),
                      hintText: LocaleKeys.supplier_company_phone_hint.tr(),
                      errorText: errors?['company_phone']?.first,
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icon(Icons.phone_rounded, color: context.primaryColor),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    CustomTextField(
                      controller: _addressController,
                      label: LocaleKeys.supplier_address_label.tr(),
                      hintText: LocaleKeys.supplier_address_hint.tr(),
                      errorText: errors?['address']?.first,
                      prefixIcon: Icon(Icons.location_on_rounded, color: context.primaryColor),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
                      decoration: BoxDecoration(
                        color: context.appSurfaceColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: context.appBorderColor),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline_rounded, color: context.primaryColor),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              LocaleKeys.supplier_is_active_label.tr(),
                              style: AppTextStyles.bodyLarge,
                            ),
                          ),
                          Switch.adaptive(
                            value: _isActive,
                            activeTrackColor: context.primaryColor,
                            onChanged: (value) {
                              setState(() {
                                _isActive = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    
                    CustomButton(
                      text: LocaleKeys.supplier_create_btn.tr(),
                      onPressed: isLoading ? () {} : () => _submit(context),
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
