import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../cubit/create/property_create_cubit.dart';
import '../cubit/create/property_create_state.dart';
import '../widgets/create/basic_data_step_widget.dart';
import '../widgets/create/deed_and_type_step_widget.dart';
import '../widgets/create/owners_and_images_step_widget.dart';
import '../widgets/create/review_publish_step_widget.dart';
import '../widgets/create/step_indicator.dart';

class PropertyCreateScreen extends StatefulWidget {
  const PropertyCreateScreen({super.key});

  @override
  State<PropertyCreateScreen> createState() => _PropertyCreateScreenState();
}

class _PropertyCreateScreenState extends State<PropertyCreateScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    context.read<PropertyCreateCubit>().initWizard();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onWillPop() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleKeys.propertyCreateExitTitle.tr(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              LocaleKeys.propertyCreateExitBody.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondaryLight),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.pop();
                    },
                    child: Text(LocaleKeys.propertyCreateExitConfirm.tr()),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(LocaleKeys.propertyCreateExitCancel.tr()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _onWillPop();
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: CustomAppBar(
          title: LocaleKeys.propertyCreateTitle.tr(),
          onBackPressed: _onWillPop,
        ),
        body: BlocConsumer<PropertyCreateCubit, PropertyCreateState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final stepLabels = state.formData?.steps.map((s) => s.label).toList() ?? [];

            return Column(
              children: [
                StepIndicator(
                  currentStep: state.currentStep,
                  stepLabels: stepLabels,
                  savedSteps: state.savedSteps,
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      DeedAndTypeStepWidget(),
                      BasicDataStepWidget(),
                      OwnersAndImagesStepWidget(),
                      ReviewPublishStepWidget(),
                    ],
                  ),
                ),
                _buildBottomNav(context, state, stepLabels.length),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, PropertyCreateState state, int totalSteps) {
    final cubit = context.read<PropertyCreateCubit>();
    final maxSteps = totalSteps == 0 ? 4 : totalSteps;
    final isLast = state.currentStep == maxSteps - 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (state.currentStep > 0)
            OutlinedButton(
              onPressed: () {
                cubit.previousStep();
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Text(LocaleKeys.propertyCreatePrevious.tr()),
            )
          else
            const SizedBox.shrink(),
          ElevatedButton(
            onPressed: state.isSaving
                ? null
                : () async {
                    if (isLast) {
                      final success = await cubit.publish();
                      if (success && context.mounted) {
                        context.pop();
                      }
                    } else {
                      final canNext = await cubit.nextStep();
                      if (canNext) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.circularLg),
            ),
            child: state.isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : Text(isLast
                    ? LocaleKeys.propertyCreatePublish.tr()
                    : LocaleKeys.propertyCreateNext.tr()),
          ),
        ],
      ),
    );
  }
}
