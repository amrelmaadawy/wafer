import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/di/service_locator.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/routing/routes.dart';
import '../cubits/details/legal_case_details_cubit.dart';
import '../cubits/details/legal_case_details_state.dart';
import '../cubits/delete/legal_case_delete_cubit.dart';
import '../cubits/delete/legal_case_delete_state.dart';
import '../cubits/add_stage/legal_case_add_stage_cubit.dart';
import '../cubits/delete_stage/legal_case_delete_stage_cubit.dart';
import '../cubits/delete_stage/legal_case_delete_stage_state.dart';
import '../widgets/details/legal_case_header_card.dart';
import '../widgets/details/legal_case_parties_card.dart';
import '../widgets/details/legal_case_property_card.dart';
import 'package:go_router/go_router.dart';
import '../widgets/legal_case_details_skeleton.dart';
import '../widgets/case_stages_timeline_widget.dart';
import '../widgets/add_legal_case_stage_bottom_sheet.dart';
import '../../../../../../core/utils/widgets/app_toast.dart';

class LegalCaseDetailsView extends StatefulWidget {
  final int legalCaseId;

  const LegalCaseDetailsView({super.key, required this.legalCaseId});

  @override
  State<LegalCaseDetailsView> createState() => _LegalCaseDetailsViewState();
}

class _LegalCaseDetailsViewState extends State<LegalCaseDetailsView> {
  late final LegalCaseDetailsCubit _cubit;
  late final LegalCaseDeleteCubit _deleteCubit;
  late final LegalCaseDeleteStageCubit _deleteStageCubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<LegalCaseDetailsCubit>()
      ..fetchLegalCaseDetails(widget.legalCaseId);
    _deleteCubit = sl<LegalCaseDeleteCubit>();
    _deleteStageCubit = sl<LegalCaseDeleteStageCubit>();
  }

  @override
  void dispose() {
    _cubit.close();
    _deleteCubit.close();
    _deleteStageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _cubit),
        BlocProvider.value(value: _deleteCubit),
        BlocProvider.value(value: _deleteStageCubit),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<LegalCaseDeleteCubit, LegalCaseDeleteState>(
            listener: (context, state) {
              if (state is LegalCaseDeleteLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => Center(
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppRadius.circularLg,
                      ),
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                );
              } else if (state is LegalCaseDeleteSuccess) {
                Navigator.of(context).pop(); // Close loading
                if (!context.mounted) return;
                AppToast.showSuccess(
                  context,
                  LocaleKeys.legal_case_deleted_success.tr(),
                );
                context.pop(true);
              } else if (state is LegalCaseDeleteError) {
                Navigator.of(context).pop(); // Close loading
                if (!context.mounted) return;
                AppToast.showError(context, state.message);
              }
            },
          ),
          BlocListener<LegalCaseDeleteStageCubit, LegalCaseDeleteStageState>(
            listener: (context, state) {
              if (state is LegalCaseDeleteStageLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => Center(
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppRadius.circularLg,
                      ),
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                );
              } else if (state is LegalCaseDeleteStageSuccess) {
                Navigator.of(context).pop(); // Close loading
                if (!context.mounted) return;
                AppToast.showSuccess(
                  context,
                  LocaleKeys.delete_stage_success.tr(),
                );
                _cubit.fetchLegalCaseDetails(
                  widget.legalCaseId,
                ); // Refresh details
              } else if (state is LegalCaseDeleteStageError) {
                Navigator.of(context).pop(); // Close loading
                if (!context.mounted) return;
                AppToast.showError(context, state.message);
              }
            },
          ),
        ],
        child: BlocBuilder<LegalCaseDetailsCubit, LegalCaseDetailsState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  LocaleKeys.case_details.tr(),
                  style: AppTextStyles.h4,
                ),
                centerTitle: true,
                backgroundColor: Colors.white,
                scrolledUnderElevation: 0,
                actions: [
                  if (state is LegalCaseDetailsLoaded)
                    IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: AppColors.primary,
                      ),
                      onPressed: () {
                        final String path =
                            '${Routes.ownerLegalCases}/${Routes.ownerLegalCaseEdit}';
                        context.push(path, extra: state.legalCase).then((
                          updated,
                        ) {
                          if (updated == true && context.mounted) {
                            _cubit.fetchLegalCaseDetails(widget.legalCaseId);
                          }
                        });
                      },
                    ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.error,
                    ),
                    onPressed: () => _showDeleteDialog(context),
                  ),
                ],
              ),
              backgroundColor: AppColors.backgroundLight,
              body: () {
                if (state is LegalCaseDetailsLoading ||
                    state is LegalCaseDetailsInitial) {
                  return const LegalCaseDetailsSkeleton();
                }

                if (state is LegalCaseDetailsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          state.message,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ElevatedButton(
                          onPressed: () =>
                              _cubit.fetchLegalCaseDetails(widget.legalCaseId),
                          child: Text(LocaleKeys.retry.tr()),
                        ),
                      ],
                    ),
                  );
                }

                if (state is LegalCaseDetailsLoaded) {
                  final legalCase = state.legalCase;
                  return RefreshIndicator(
                    onRefresh: () async {
                      await _cubit.fetchLegalCaseDetails(widget.legalCaseId);
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          LegalCaseHeaderCard(legalCase: legalCase),
                          const SizedBox(height: AppSpacing.md),
                          LegalCasePartiesCard(legalCase: legalCase),
                          if (legalCase.property != null ||
                              legalCase.contract != null) ...[
                            const SizedBox(height: AppSpacing.md),
                            LegalCasePropertyCard(legalCase: legalCase),
                          ],
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LocaleKeys.timeline.tr(),
                                style: AppTextStyles.h4.copyWith(
                                  color: AppColors.textPrimaryLight,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () => _showAddStageBottomSheet(
                                  context,
                                  widget.legalCaseId,
                                ),
                                icon: const Icon(Icons.add, size: 18),
                                label: Text(LocaleKeys.add_stage.tr()),
                                style: TextButton.styleFrom(
                                  foregroundColor: context.primaryColor,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppRadius.circularMd,
                                    side: BorderSide(
                                      color: context.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          if (legalCase.stages != null &&
                              legalCase.stages!.isNotEmpty)
                            CaseStagesTimelineWidget(
                              stages: legalCase.stages!,
                              onDeleteStage: (stageId) =>
                                  _showDeleteStageDialog(
                                    context,
                                    widget.legalCaseId,
                                    stageId,
                                  ),
                            )
                          else
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.xl * 1.5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundLight,
                                borderRadius: AppRadius.circularLg,
                                border: Border.all(
                                  color: AppColors.borderLight.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.timeline_rounded,
                                    size: 48,
                                    color: AppColors.borderLight,
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    LocaleKeys.no_stages_found.tr(),
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondaryLight,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }

                return const SizedBox();
              }(),
            );
          },
        ),
      ),
    );
  }

  void _showAddStageBottomSheet(BuildContext context, int legalCaseId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => BlocProvider(
        create: (_) => sl<LegalCaseAddStageCubit>(),
        child: AddLegalCaseStageBottomSheet(legalCaseId: legalCaseId),
      ),
    ).then((result) {
      if (result == true) {
        _cubit.fetchLegalCaseDetails(widget.legalCaseId);
      }
    });
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          LocaleKeys.delete_legal_case_confirm_title.tr(),
          style: AppTextStyles.h4.copyWith(color: AppColors.error),
        ),
        content: Text(
          LocaleKeys.delete_legal_case_confirm_body.tr(),
          style: AppTextStyles.bodyMedium,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.circularLg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              LocaleKeys.cancel.tr(),
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _deleteCubit.deleteLegalCase(widget.legalCaseId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(
              LocaleKeys.delete_legal_case_confirm_btn.tr(),
              style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteStageDialog(
    BuildContext context,
    int legalCaseId,
    int stageId,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          LocaleKeys.delete_stage_confirmation_title.tr(),
          style: AppTextStyles.h4.copyWith(color: AppColors.error),
        ),
        content: Text(
          LocaleKeys.delete_stage_confirmation_desc.tr(),
          style: AppTextStyles.bodyMedium,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.circularLg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              LocaleKeys.cancel.tr(),
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _deleteStageCubit.deleteStage(
                legalCaseId: legalCaseId,
                stageId: stageId,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(
              LocaleKeys.delete_stage.tr(),
              style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
