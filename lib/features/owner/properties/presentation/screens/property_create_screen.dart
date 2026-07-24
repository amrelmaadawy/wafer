import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';
import '../cubit/create/property_create_cubit.dart';
import '../cubit/create/property_create_state.dart';
import '../widgets/create/wizard_progress_bar.dart';
import '../views/create/step1_basic_info_view.dart';
import '../views/create/step2_details_view.dart';
import '../views/create/step3_images_view.dart';
import '../views/create/step4_owners_view.dart';
import '../views/create/step5_review_view.dart';

class PropertyCreateScreen extends StatefulWidget {
  const PropertyCreateScreen({super.key});

  @override
  State<PropertyCreateScreen> createState() => _PropertyCreateScreenState();
}

class _PropertyCreateScreenState extends State<PropertyCreateScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    context.read<PropertyCreateCubit>().loadFormOptions();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext(PropertyCreateCubit cubit, PropertyCreateState state) async {
    // Basic Info validation
    if (state.currentStep == 0) {
      if (state.selectedBranchId == null || state.selectedDeedId == null || state.selectedType == null) {
        if (mounted) AppToast.showError(context, 'يرجى إكمال جميع الحقول المطلوبة');
        return;
      }
      final success = await cubit.createDraft();
      if (!success) return;
    }

    // Images save
    if (state.currentStep == 2) {
      if (state.images.any((i) => i.isUploading)) {
        if (mounted) AppToast.showError(context, 'يرجى الانتظار حتى يكتمل رفع الصور');
        return;
      }
      if (state.images.isNotEmpty) {
        final success = await cubit.saveImages();
        if (!success) return;
      }
    }

    // Owners validation & sync
    if (state.currentStep == 3) {
      final success = await cubit.syncOwners();
      if (!success) return;
    }

    // Publish
    if (state.currentStep == 4) {
      final success = await cubit.publishProperty();
      if (success && mounted) {
        AppToast.showSuccess(context, LocaleKeys.propertyWizardPublishedSuccess.tr());
        context.pushReplacement('${Routes.ownerPropertyDetails}?id=${state.draftPropertyId}');
      }
      return;
    }

    cubit.nextStep();
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPrevious(PropertyCreateCubit cubit) {
    cubit.previousStep();
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(
        title: LocaleKeys.propertyCreateTitle.tr(),
      ),
      body: BlocConsumer<PropertyCreateCubit, PropertyCreateState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            AppToast.showError(context, state.errorMessage!);
            context.read<PropertyCreateCubit>().clearError();
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final cubit = context.read<PropertyCreateCubit>();

          return PopScope(
            canPop: state.currentStep == 0,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              _onPrevious(cubit);
            },
            child: Column(
              children: [
                WizardProgressBar(currentStep: state.currentStep),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(), // Disable swipe to force using buttons
                    children: const [
                      Step1BasicInfoView(),
                      Step2DetailsView(),
                      Step3ImagesView(),
                      Step4OwnersView(),
                      Step5ReviewView(),
                    ],
                  ),
                ),
                _buildBottomNav(context, state, cubit),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, PropertyCreateState state, PropertyCreateCubit cubit) {
    final isLastStep = state.currentStep == 4;
    final isBusy = state.isSaving || state.isSavingImages || state.isSyncingOwners || state.isPublishing;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (state.currentStep > 0)
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: isBusy ? null : () => _onPrevious(cubit),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.circularLg),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  child: Text(
                    LocaleKeys.propertyWizardPrevious.tr(),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textSecondaryLight),
                  ),
                ),
              ),
            if (state.currentStep > 0) const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: isBusy
                  ? AppShimmer.box(
                      height: 52,
                      borderRadius: AppRadius.circularLg,
                    )
                  : ElevatedButton(
                      onPressed: () => _onNext(cubit, state),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isLastStep ? AppColors.success : context.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.circularLg),
                      ),
                      child: Text(
                        isLastStep ? LocaleKeys.propertyWizardPublish.tr() : LocaleKeys.propertyWizardNext.tr(),
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
