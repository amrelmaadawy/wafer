import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:wafer/core/theme/app_radius.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../cubit/create/property_create_cubit.dart';
import '../cubit/create/property_create_state.dart';
import '../widgets/create/wizard_progress_bar.dart';
import '../widgets/create/create_property_bottom_nav.dart';
import '../views/create/step1_basic_info_view.dart';
import '../views/create/step2_details_view.dart';
import '../views/create/step3_images_view.dart';
import '../views/create/step4_owners_view.dart';
import '../views/create/step5_review_view.dart';
import '../widgets/create/property_create_skeleton.dart';

class PropertyCreateScreen extends StatefulWidget {
  const PropertyCreateScreen({super.key});

  @override
  State<PropertyCreateScreen> createState() => _PropertyCreateScreenState();
}

class _PropertyCreateScreenState extends State<PropertyCreateScreen> {
  late PageController _pageController;
  late PropertyCreateCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<PropertyCreateCubit>();
    _cubit.reset(); // Clear any previous draft data
    _pageController = PageController(initialPage: _cubit.state.currentStep);
    _cubit.loadFormOptions();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _cubit.reset(); // Ensure data is cleared when leaving the screen
    super.dispose();
  }

  void _onNext(PropertyCreateCubit cubit, PropertyCreateState state) async {
    if (state.currentStep == 0) {
      if (state.selectedBranchId == null ||
          state.selectedDeedId == null ||
          state.selectedType == null) {
        if (mounted) {
          AppToast.showError(
            context,
            LocaleKeys.propertyCreateFillRequired.tr(),
          );
        }
        return;
      }
      final success = await cubit.createDraft();
      if (!success || !mounted) return;
    }

    if (state.currentStep == 1) {
      if (state.name == null || state.name!.trim().isEmpty) {
        if (mounted) {
          AppToast.showError(
            context,
            LocaleKeys.propertyCreateNameRequired.tr(),
          );
        }
        return;
      }
      if (state.usageType == null || state.usageType!.trim().isEmpty) {
        if (mounted) {
          AppToast.showError(
            context,
            "Ù†ÙˆØ¹ Ø§Ù„Ø§Ø³ØªØ®Ø¯Ø§Ù… Ù…Ø·Ù„ÙˆØ¨",
          );
        }
        return;
      }
      final currentYear = DateTime.now().year;
      if (state.constructionYear != null &&
          (state.constructionYear! < 1900 ||
              state.constructionYear! > currentYear)) {
        if (mounted) {
          AppToast.showError(
            context,
            "Ø³Ù†Ø© Ø§Ù„Ø¨Ù†Ø§Ø¡ ØºÙŠØ± ØµØ§Ù„Ø­Ø©. ÙŠØ¬Ø¨ Ø£Ù† ØªÙƒÙˆÙ† Ø¨ÙŠÙ† 1900 Ùˆ $currentYear",
          );
        }
        return;
      }
      FocusScope.of(context).unfocus();
      final success = await cubit.autoSaveDetails();
      if (!success || !mounted) return;
    }

    if (state.currentStep == 2) {
      if (state.images.any((i) => i.isUploading)) {
        if (mounted) {
          AppToast.showError(
            context,
            LocaleKeys.propertyCreateImagesUploading.tr(),
          );
        }
        return;
      }
      if (state.images.isNotEmpty) {
        final success = await cubit.saveImages();
        if (!success || !mounted) return;
      }
    }

    if (state.currentStep == 3) {
      final success = await cubit.syncOwners();
      if (!success || !mounted) return;
    }

    if (state.currentStep == 4) {
      final success = await cubit.publishProperty();
      if (success && mounted) {
        final id = state.draftPropertyId;
        AppToast.showSuccess(
          context,
          LocaleKeys.propertyWizardPublishedSuccess.tr(),
        );
        cubit.reset();
        context.pushReplacement(Routes.ownerPropertyDetailsPath(id.toString()));
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
      appBar: CustomAppBar(title: LocaleKeys.propertyCreateTitle.tr()),
      body: BlocConsumer<PropertyCreateCubit, PropertyCreateState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            AppToast.showError(context, state.errorMessage!);
            context.read<PropertyCreateCubit>().clearError();
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const PropertyCreateSkeleton();
          }

          final cubit = context.read<PropertyCreateCubit>();

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;
              if (state.currentStep == 0) {
                final shouldPop = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.circularXxl,
                    ),
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppRadius.circularXxl,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.logout_rounded,
                              color: AppColors.error,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            state.draftPropertyId != null
                                ? LocaleKeys.propertyCreateExitTitle.tr()
                                : "Ø¥Ù„ØºØ§Ø¡ Ø§Ù„Ø¥Ø¶Ø§ÙØ©",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimaryLight,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            state.draftPropertyId != null
                                ? LocaleKeys.propertyCreateExitMessage.tr()
                                : "Ù‡Ù„ Ø£Ù†Øª Ù…ØªØ£ÙƒØ¯ Ù…Ù† Ø±ØºØ¨ØªÙƒ ÙÙŠ Ø¥Ù„ØºØ§Ø¡ Ø§Ù„Ø¥Ø¶Ø§ÙØ©ØŸ Ù„Ù† ÙŠØªÙ… Ø­ÙØ¸ Ø£ÙŠ Ø¨ÙŠØ§Ù†Ø§Øª ÙƒÙ…Ø³ÙˆØ¯Ø©.",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondaryLight,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: AppRadius.circularXl,
                                    ),
                                    foregroundColor: AppColors.textSecondaryLight,
                                  ),
                                  child: Text(
                                    LocaleKeys.propertyCreateExitCancel.tr(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.error,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: AppRadius.circularXl,
                                    ),
                                  ),
                                  child: Text(
                                    LocaleKeys.propertyCreateExitConfirm.tr(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
                if (shouldPop == true && context.mounted) {
                  context.pop();
                }
              } else {
                _onPrevious(cubit);
              }
            },
            child: Column(
              children: [
                WizardProgressBar(currentStep: state.currentStep),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      const Step1BasicInfoView(),
                      const Step2DetailsView(),
                      const Step3ImagesView(),
                      const Step4OwnersView(),
                      Step5ReviewView(
                        onGoToStep: (step) {
                          _pageController.animateToPage(
                            step,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                CreatePropertyBottomNav(
                  state: state,
                  onNext: () => _onNext(cubit, state),
                  onPrevious: () => _onPrevious(cubit),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


