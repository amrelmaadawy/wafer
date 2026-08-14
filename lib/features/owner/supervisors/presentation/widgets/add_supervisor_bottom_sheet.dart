import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../core/utils/widgets/custom_button.dart';
import '../cubit/form_data/supervisor_form_data_cubit.dart';
import '../cubit/form_data/supervisor_form_data_state.dart';
import '../cubit/create/create_supervisor_cubit.dart';
import 'supervisor_form.dart';
import 'supervisor_form_skeleton.dart';

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
                    return const SupervisorFormSkeleton();
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
                    return SupervisorForm(data: state.data);
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

