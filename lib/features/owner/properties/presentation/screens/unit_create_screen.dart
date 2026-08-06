import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/utils/widgets/custom_button.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../cubit/units/unit_create_cubit.dart';
import '../cubit/units/unit_create_state.dart';
import '../widgets/units/create/step1_basic_info_view.dart';
import '../widgets/units/create/step2_specs_view.dart';
import '../widgets/units/create/step3_location_utilities_view.dart';
import '../widgets/units/create/step4_images_view.dart';
import '../widgets/units/create/step5_financials_view.dart';
import '../widgets/units/create/step6_review_view.dart';
import '../widgets/units/create/wizard_progress_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';

class UnitCreateScreen extends StatelessWidget {
  final int propertyId;

  const UnitCreateScreen({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UnitCreateCubit>()..init(propertyId),
      child: const _UnitCreateScreenContent(),
    );
  }
}

class _UnitCreateScreenContent extends StatefulWidget {
  const _UnitCreateScreenContent();

  @override
  State<_UnitCreateScreenContent> createState() =>
      _UnitCreateScreenContentState();
}

class _UnitCreateScreenContentState extends State<_UnitCreateScreenContent> {
  final PageController _pageController = PageController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onStepChanged(BuildContext context, int newStep) {
    _pageController.animateToPage(
      newStep,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UnitCreateCubit, UnitCreateState>(
      listenWhen: (previous, current) {
        if (previous.error != current.error && current.error != null) {
          return true;
        }
        if (previous.currentStep != current.currentStep) return true;
        return false;
      },
      listener: (context, state) {
        if (state.error != null) {
          AppToast.showError(context, state.error!);
        }
        if (_pageController.hasClients &&
            _pageController.page?.round() != state.currentStep) {
          _onStepChanged(context, state.currentStep);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(
            title: LocaleKeys.unitsAddNewUnit.tr(),
            onBackPressed: () {
              if (state.currentStep > 0) {
                context.read<UnitCreateCubit>().previousStep();
              } else {
                _showExitDialog(context);
              }
            },
          ),
          body: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;

              if (state.currentStep > 0) {
                context.read<UnitCreateCubit>().previousStep();
              } else {
                _showExitDialog(context);
              }
            },
            child: Column(
              children: [
                WizardProgressBar(
                  currentStep: state.currentStep,
                  totalSteps: 6,
                ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: const [
                        Step1BasicInfoView(),
                        Step2SpecsView(),
                        Step3LocationUtilitiesView(),
                        Step4ImagesView(),
                        Step5FinancialsView(),
                        Step6ReviewView(),
                      ],
                    ),
                  ),
                ),
                _buildBottomNavigation(context, state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigation(BuildContext context, UnitCreateState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (state.currentStep > 0) ...[
              Expanded(
                child: CustomButton(
                  text: LocaleKeys.unitsWizardPrevious.tr(),
                  onPressed: () =>
                      context.read<UnitCreateCubit>().previousStep(),
                  type: ButtonType.secondary,
                ),
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              flex: 2,
              child: CustomButton(
                text: state.currentStep == 5
                    ? LocaleKeys.unitsWizardSubmit.tr()
                    : LocaleKeys.unitsWizardNext.tr(),
                isLoading: state.isLoading,
                onPressed: () async {
                  if (state.currentStep == 5) {
                    final success = await context
                        .read<UnitCreateCubit>()
                        .submit();
                    if (success && context.mounted) {
                      AppToast.showSuccess(
                        context,
                        LocaleKeys.unitsWizardSuccess.tr(),
                      );
                      context.pop(true); // Return true to refresh units list
                    }
                  } else {
                    if (_formKey.currentState?.validate() ?? false) {
                      context.read<UnitCreateCubit>().nextStep();
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showExitDialog(BuildContext context) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(LocaleKeys.propertyCreateExitCancel.tr()),
        content: Text(LocaleKeys.propertyCreateExitMessage.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(LocaleKeys.cancel.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(LocaleKeys.propertyCreateExitCancel.tr()),
          ),
        ],
      ),
    );

    if (shouldExit == true && context.mounted) {
      context.pop();
    }
  }
}
