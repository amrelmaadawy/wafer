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
import '../../domain/entities/suppliers/supplier_entity.dart';
import '../../domain/entities/suppliers/update_owner_supplier_params.dart';
import '../cubit/suppliers/update/owner_supplier_update_cubit.dart';
import '../cubit/suppliers/update/owner_supplier_update_state.dart';

class OwnerSupplierUpdateView extends StatefulWidget {
  final SupplierEntity supplier;

  const OwnerSupplierUpdateView({super.key, required this.supplier});

  @override
  State<OwnerSupplierUpdateView> createState() => _OwnerSupplierUpdateViewState();
}

class _OwnerSupplierUpdateViewState extends State<OwnerSupplierUpdateView> {
  final _formKey = GlobalKey<FormState>();
  
  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _contactController;
  late final TextEditingController _taxController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _companyPhoneController;
  late final TextEditingController _addressController;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.supplier.supplierCode);
    _nameController = TextEditingController(text: widget.supplier.companyName);
    _contactController = TextEditingController(text: widget.supplier.contactPerson);
    _taxController = TextEditingController(text: widget.supplier.taxNumber);
    _emailController = TextEditingController(text: widget.supplier.email);
    _phoneController = TextEditingController(text: widget.supplier.phone);
    _companyPhoneController = TextEditingController(text: widget.supplier.companyPhone);
    _addressController = TextEditingController(text: widget.supplier.address);
    _isActive = widget.supplier.isActive;
  }

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
      final params = UpdateOwnerSupplierParams(
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
      
      context.read<OwnerSupplierUpdateCubit>().updateSupplier(widget.supplier.id, params);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OwnerSupplierUpdateCubit>(),
      child: BlocConsumer<OwnerSupplierUpdateCubit, OwnerSupplierUpdateState>(
        listener: (context, state) {
          if (state is OwnerSupplierUpdateSuccess) {
            // We use the same translation key as requested or add a new one later
            AppToast.showSuccess(context, LocaleKeys.supplier_update_success.tr());
            context.pop(true); // Return true to indicate success
          } else if (state is OwnerSupplierUpdateError) {
            AppToast.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is OwnerSupplierUpdateLoading;
          final errors = (state is OwnerSupplierUpdateError) ? state.validationErrors : null;

          return Scaffold(
            backgroundColor: context.appBackgroundColor,
            appBar: CustomAppBar(
              title: LocaleKeys.supplier_update_title.tr(),
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
                      validator: (value) => value == null || value.trim().isEmpty ? 'Ù…Ø·Ù„ÙˆØ¨' : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    CustomTextField(
                      controller: _nameController,
                      label: LocaleKeys.supplier_company_name_label.tr(),
                      hintText: LocaleKeys.supplier_company_name_hint.tr(),
                      errorText: errors?['company_name']?.first,
                      prefixIcon: Icon(Icons.storefront_rounded, color: context.primaryColor),
                      validator: (value) => value == null || value.trim().isEmpty ? 'Ù…Ø·Ù„ÙˆØ¨' : null,
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
                      text: LocaleKeys.supplier_update_btn.tr(),
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
