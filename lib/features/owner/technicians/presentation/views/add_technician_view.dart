import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../../../core/utils/widgets/custom_button.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../cubits/technician_form_data_cubit.dart';
import '../cubits/technician_form_data_state.dart';
import '../cubit/add/add_technician_cubit.dart';
import '../cubit/add/add_technician_state.dart';

class AddTechnicianView extends StatelessWidget {
  const AddTechnicianView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<TechnicianFormDataCubit>()..getFormData(),
        ),
        BlocProvider(
          create: (context) => sl<AddTechnicianCubit>(),
        ),
      ],
      child: const _AddTechnicianViewBody(),
    );
  }
}

class _AddTechnicianViewBody extends StatefulWidget {
  const _AddTechnicianViewBody();

  @override
  State<_AddTechnicianViewBody> createState() => _AddTechnicianViewBodyState();
}

class _AddTechnicianViewBodyState extends State<_AddTechnicianViewBody> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _companyController = TextEditingController();
  bool _isActive = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _specialtyController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AddTechnicianCubit>().submit(
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            specialty: _specialtyController.text.trim(),
            companyName: _companyController.text.trim(),
            isActive: _isActive,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          LocaleKeys.addTechnician.tr(),
          style: const TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
      ),
      body: BlocListener<AddTechnicianCubit, AddTechnicianState>(
        listener: (context, state) {
          if (state is AddTechnicianSuccess) {
            AppToast.showSuccess(
              context,
              LocaleKeys.propertyImagesSaveSuccess.tr(),
            );
            context.pop();
          } else if (state is AddTechnicianFailure) {
            AppToast.showError(
              context,
              state.errorMessage,
            );
          }
        },
        child: BlocConsumer<TechnicianFormDataCubit, TechnicianFormDataState>(
          listener: (context, state) {
            if (state is TechnicianFormDataSuccess) {
              setState(() {
                _isActive = state.data.defaults.isActive;
              });
            } else if (state is TechnicianFormDataError) {
              AppToast.showError(
                context,
                state.message,
              );
            }
          },
          builder: (context, state) {
            if (state is TechnicianFormDataLoading ||
                state is TechnicianFormDataInitial) {
              return const _TechnicianFormSkeleton();
            }

            if (state is TechnicianFormDataError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                        context.read<TechnicianFormDataCubit>().getFormData();
                      },
                    ),
                  ],
                ),
              );
            }

            if (state is TechnicianFormDataSuccess) {
              final data = state.data;
              final validation = data.validation;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        controller: _nameController,
                        label: LocaleKeys.technicianName.tr(),
                        hintText: LocaleKeys.technicianName.tr(),
                        maxLength: validation.name['max'] as int?,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return LocaleKeys.techNameValidation.tr();
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      CustomTextField(
                        controller: _phoneController,
                        label: LocaleKeys.technicianPhone.tr(),
                        hintText: LocaleKeys.technicianPhone.tr(),
                        keyboardType: TextInputType.phone,
                        maxLength: validation.phone['max'] as int?,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      CustomTextField(
                        controller: _specialtyController,
                        label: LocaleKeys.technicianSpecialty.tr(),
                        hintText: LocaleKeys.technicianSpecialty.tr(),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      CustomTextField(
                        controller: _companyController,
                        label: LocaleKeys.technicianCompany.tr(),
                        hintText: LocaleKeys.technicianCompany.tr(),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            LocaleKeys.isActive.tr(),
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
                      BlocBuilder<AddTechnicianCubit, AddTechnicianState>(
                        builder: (context, addState) {
                          return CustomButton(
                            text: LocaleKeys.addTechnician.tr(),
                            isLoading: addState is AddTechnicianLoading,
                            onPressed:
                                addState is AddTechnicianLoading ? () {} : _submitForm,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _TechnicianFormSkeleton extends StatelessWidget {
  const _TechnicianFormSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg),
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
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ],
      ),
    );
  }
}

