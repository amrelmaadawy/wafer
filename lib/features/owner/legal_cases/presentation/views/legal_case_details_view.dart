import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/features/owner/legal_cases/domain/entities/legal_case_item_entity.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/di/service_locator.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../cubits/details/legal_case_details_cubit.dart';
import '../cubits/details/legal_case_details_state.dart';
import '../cubits/delete/legal_case_delete_cubit.dart';
import '../cubits/delete/legal_case_delete_state.dart';
import '../cubits/add_stage/legal_case_add_stage_cubit.dart';
import 'package:go_router/go_router.dart';
import '../widgets/legal_case_details_skeleton.dart';
import '../widgets/case_stages_timeline_widget.dart';
import '../widgets/add_legal_case_stage_bottom_sheet.dart';

class LegalCaseDetailsView extends StatefulWidget {
  final int legalCaseId;

  const LegalCaseDetailsView({
    super.key,
    required this.legalCaseId,
  });

  @override
  State<LegalCaseDetailsView> createState() => _LegalCaseDetailsViewState();
}

class _LegalCaseDetailsViewState extends State<LegalCaseDetailsView> {
  late final LegalCaseDetailsCubit _cubit;
  late final LegalCaseDeleteCubit _deleteCubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<LegalCaseDetailsCubit>()..fetchLegalCaseDetails(widget.legalCaseId);
    _deleteCubit = sl<LegalCaseDeleteCubit>();
  }

  @override
  void dispose() {
    _cubit.close();
    _deleteCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _cubit),
        BlocProvider.value(value: _deleteCubit),
      ],
      child: BlocListener<LegalCaseDeleteCubit, LegalCaseDeleteState>(
        listener: (context, state) {
          if (state is LegalCaseDeleteLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state is LegalCaseDeleteSuccess) {
            Navigator.of(context).pop(); // Close loading
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(LocaleKeys.legal_case_deleted_success.tr()),
                backgroundColor: AppColors.success,
              ),
            );
            context.pop(true);
          } else if (state is LegalCaseDeleteError) {
            Navigator.of(context).pop(); // Close loading
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(LocaleKeys.case_details.tr(), style: AppTextStyles.h4),
            centerTitle: true,
            backgroundColor: Colors.white,
            scrolledUnderElevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                onPressed: () => _showDeleteDialog(context),
              ),
            ],
          ),
        backgroundColor: AppColors.backgroundLight,
        body: BlocBuilder<LegalCaseDetailsCubit, LegalCaseDetailsState>(
          builder: (context, state) {
            if (state is LegalCaseDetailsLoading || state is LegalCaseDetailsInitial) {
              return const LegalCaseDetailsSkeleton();
            }

            if (state is LegalCaseDetailsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      state.message,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () => _cubit.fetchLegalCaseDetails(widget.legalCaseId),
                      child: Text(LocaleKeys.retry.tr()),
                    ),
                  ],
                ),
              );
            }

            if (state is LegalCaseDetailsLoaded) {
              final legalCase = state.legalCase;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeaderCard(legalCase),
                    const SizedBox(height: AppSpacing.md),
                    _buildPartiesCard(legalCase),
                    const SizedBox(height: AppSpacing.md),
                    if (legalCase.property != null) ...[
                      _buildPropertyCard(legalCase),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          LocaleKeys.timeline.tr(),
                          style: AppTextStyles.h4.copyWith(color: AppColors.textPrimaryLight),
                        ),
                        TextButton.icon(
                          onPressed: () => _showAddStageBottomSheet(context, widget.legalCaseId),
                          icon: const Icon(Icons.add, size: 18),
                          label: Text(LocaleKeys.add_stage.tr()),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primaryDark,
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (legalCase.stages != null && legalCase.stages!.isNotEmpty)
                      CaseStagesTimelineWidget(stages: legalCase.stages!)
                    else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl * 1.5),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundLight,
                          borderRadius: AppRadius.circularLg,
                          border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.5)),
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
              );
            }

            return const SizedBox();
          },
        ),
      ),
    ));
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
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.circularLg,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              LocaleKeys.cancel.tr(),
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondaryLight),
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

  Widget _buildHeaderCard(LegalCaseItemEntity legalCase) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.circularLg,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                legalCase.caseNumber ?? '',
                style: AppTextStyles.h4.copyWith(color: AppColors.textPrimaryLight),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(legalCase.statusColor, context).withValues(alpha: 0.1),
                  borderRadius: AppRadius.circularMd,
                ),
                child: Text(
                  legalCase.status ?? '',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: _getStatusColor(legalCase.statusColor, context),
                    fontWeight: AppFonts.semiBold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.borderLight, height: 1),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _buildInfoColumn(LocaleKeys.case_type.tr(), legalCase.caseType ?? '-'),
              ),
              Expanded(
                child: _buildInfoColumn(LocaleKeys.court.tr(), legalCase.court ?? '-'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _buildInfoColumn(LocaleKeys.circuit.tr(), legalCase.circuit ?? '-'),
              ),
              Expanded(
                child: _buildInfoColumn(LocaleKeys.amount.tr(), legalCase.amount?.toString() ?? '-'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPartiesCard(LegalCaseItemEntity legalCase) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.circularLg,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.parties_and_lawyer.tr(),
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimaryLight),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.borderLight, height: 1),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _buildInfoColumn(LocaleKeys.plaintiff.tr(), legalCase.parties?.plaintiff ?? '-'),
              ),
              Expanded(
                child: _buildInfoColumn(LocaleKeys.defendant.tr(), legalCase.parties?.defendant ?? '-'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildInfoColumn(LocaleKeys.lawyer.tr(), legalCase.lawyer?.name ?? '-'),
        ],
      ),
    );
  }

  Widget _buildPropertyCard(LegalCaseItemEntity legalCase) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.circularLg,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.related_property.tr(),
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimaryLight),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.borderLight, height: 1),
          const SizedBox(height: AppSpacing.md),
          _buildInfoColumn(LocaleKeys.property_name.tr(), legalCase.property?.name ?? '-'),
          if (legalCase.contract != null) ...[
            const SizedBox(height: AppSpacing.md),
            _buildInfoColumn(LocaleKeys.contract_number.tr(), legalCase.contract?.contractNumber ?? '-'),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondaryLight),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimaryLight),
        ),
      ],
    );
  }

  Color _getStatusColor(String? colorCode, BuildContext context) {
    if (colorCode == null) return AppColors.primaryDark;
    switch (colorCode) {
      case 'primary':
        return context.primaryColor;
      case 'success':
        return AppColors.success;
      case 'danger':
        return AppColors.error;
      case 'warning':
        return AppColors.warning;
      case 'info':
        return AppColors.info;
      case 'dark':
        return AppColors.primaryDark;
      case 'light':
        return AppColors.surfaceLight;
      default:
        return AppColors.primaryDark;
    }
  }
}
