import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../../core/utils/widgets/app_shimmer.dart';
import '../../../../../../core/utils/widgets/custom_button.dart';
import '../../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../../../../core/di/service_locator.dart';
import '../cubit/form_data/negotiation_form_data_cubit.dart';
import '../cubit/form_data/negotiation_form_data_state.dart';
import '../cubit/create/create_negotiation_cubit.dart';
import '../cubit/create/create_negotiation_state.dart';
import '../../../../../../core/utils/widgets/app_toast.dart';

class NegotiationSettingsView extends StatefulWidget {
  const NegotiationSettingsView({super.key});

  @override
  State<NegotiationSettingsView> createState() => _NegotiationSettingsViewState();
}

class _NegotiationSettingsViewState extends State<NegotiationSettingsView> {
  final _formKey = GlobalKey<FormState>();
  final _approvalLimitController = TextEditingController();
  bool _isActive = true;
  num? _minLimit;

  @override
  void dispose() {
    _approvalLimitController.dispose();
    super.dispose();
  }

  void _onDataLoaded(NegotiationFormDataState state) {
    if (state.formData != null) {
      final data = state.formData!;
      
      final current = data.currentNegotiation;
      final defaults = data.defaults;
      
      _minLimit = data.validation?.approvalLimitMin;

      if (current != null) {
        _approvalLimitController.text = current.approvalLimit.toString();
        _isActive = current.isActive;
      } else if (defaults != null) {
        _approvalLimitController.text = defaults.approvalLimit.toString();
        _isActive = defaults.isActive;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<NegotiationFormDataCubit>()..getFormData()),
        BlocProvider(create: (_) => sl<CreateNegotiationCubit>()),
      ],
      child: Scaffold(
        appBar: CustomAppBar(
          title: LocaleKeys.negotiation_settings_title.tr(),
          showBackButton: true,
        ),
        body: BlocConsumer<NegotiationFormDataCubit, NegotiationFormDataState>(
          listener: (context, state) {
            if (state.status == NegotiationFormDataStatus.success) {
              _onDataLoaded(state);
            }
          },
          builder: (context, state) {
            if (state.status == NegotiationFormDataStatus.initial ||
                state.status == NegotiationFormDataStatus.loading) {
              return const _NegotiationSettingsSkeleton();
            }

            if (state.status == NegotiationFormDataStatus.failure) {
              return CustomErrorWidget(
                message: state.errorMessage ?? '',
                onRetry: () => context.read<NegotiationFormDataCubit>().getFormData(),
              );
            }

            return _buildForm(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, NegotiationFormDataState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: AppRadius.circularMd,
                border: Border.all(color: AppColors.borderLight),
                boxShadow: [
                  BoxShadow(
                    color: context.primaryShadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: _approvalLimitController,
                    label: LocaleKeys.negotiation_approval_limit.tr(),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return LocaleKeys.negotiation_validation_required.tr();
                      }
                      final numValue = num.tryParse(value);
                      if (numValue == null) {
                        return LocaleKeys.negotiation_validation_required.tr();
                      }
                      if (_minLimit != null && numValue < _minLimit!) {
                        return LocaleKeys.negotiation_validation_min.tr(args: [_minLimit.toString()]);
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocaleKeys.negotiation_is_active.tr(),
                        style: AppTextStyles.h4,
                      ),
                      Switch.adaptive(
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
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            BlocConsumer<CreateNegotiationCubit, CreateNegotiationState>(
              listener: (context, state) {
                if (state is CreateNegotiationSuccess) {
                  AppToast.showSuccess(context, LocaleKeys.negotiation_create_success.tr());
                  Navigator.pop(context, true);
                } else if (state is CreateNegotiationFailure) {
                  AppToast.showError(context, state.errorMessage);
                }
              },
              builder: (context, state) {
                return CustomButton(
                  text: LocaleKeys.negotiation_save_settings.tr(),
                  isLoading: state is CreateNegotiationLoading,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<CreateNegotiationCubit>().createNegotiation(
                            approvalLimit: num.parse(_approvalLimitController.text),
                            isActive: _isActive,
                          );
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NegotiationSettingsSkeleton extends StatelessWidget {
  const _NegotiationSettingsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: AppRadius.circularMd,
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmer.box(width: double.infinity, height: 50, borderRadius: AppRadius.circularMd),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppShimmer.box(width: 100, height: 20),
                    AppShimmer.box(width: 40, height: 24, borderRadius: AppRadius.circularLg),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          AppShimmer.box(width: double.infinity, height: 50, borderRadius: AppRadius.circularLg),
        ],
      ),
    );
  }
}
