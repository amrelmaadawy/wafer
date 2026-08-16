import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/core/di/service_locator.dart' as di;
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../domain/entities/maintenance_item_entity.dart';
import '../../domain/entities/maintenance_status_extension.dart';
import '../cubit/details/owner_maintenance_details_cubit.dart';
import '../cubit/execute_maintenance/owner_execute_maintenance_cubit.dart';
import '../cubit/verify_close_maintenance/owner_verify_close_maintenance_cubit.dart';
import '../../domain/entities/execute_owner_maintenance_response_entity.dart';
import 'owner_assign_maintenance_bottom_sheet.dart';
import 'owner_start_maintenance_dialog.dart';
import 'owner_execute_maintenance_bottom_sheet.dart';
import 'owner_verify_close_maintenance_bottom_sheet.dart';
import 'owner_qa_code_dialog.dart';
import 'maintenance_action_sheets_helper.dart';

class MaintenanceDetailsBottomBar extends StatelessWidget {
  final MaintenanceItemEntity displayItem;
  final Function(bool) onModified;

  const MaintenanceDetailsBottomBar({
    super.key,
    required this.displayItem,
    required this.onModified,
  });

  @override
  Widget build(BuildContext context) {
    if (displayItem.canApprove || displayItem.canReject) {
      return _ActionBarContainer(
        child: Row(
          children: [
            Expanded(
              child: _buildButton(
                context,
                title: LocaleKeys.maintenanceApproveRequest.tr(),
                onPressed: () =>
                    MaintenanceActionSheetsHelper.showApproveBottomSheet(
                      context,
                      displayItem.safeId,
                    ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: OutlinedButton(
                onPressed: () =>
                    MaintenanceActionSheetsHelper.showRejectBottomSheet(
                      context,
                      displayItem.safeId,
                    ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.circularLg,
                  ),
                ),
                child: Text(
                  LocaleKeys.maintenanceRejectRequest.tr(),
                  style: AppTextStyles.h4.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (displayItem.canAssign) {
      return _ActionBarContainer(
        child: _buildButton(
          context,
          title: LocaleKeys.maintenanceAssignTechnician.tr(),
          onPressed: () async {
            final result = await OwnerAssignMaintenanceBottomSheet.show(
              context,
              displayItem,
            );
            if (result == true && context.mounted) {
              onModified(true);
            }
          },
        ),
      );
    } else if (displayItem.canStart) {
      return _ActionBarContainer(
        child: _buildButton(
          context,
          title: LocaleKeys.maintenanceStartWork.tr(),
          onPressed: () async {
            final result = await OwnerStartMaintenanceDialog.show(
              context,
              displayItem.safeId,
            );
            if (result == true && context.mounted) {
              onModified(true);
              context
                  .read<OwnerMaintenanceDetailsCubit>()
                  .getMaintenanceDetails(displayItem.safeId);
            }
          },
        ),
      );
    } else if (displayItem.canExecute) {
      return _ActionBarContainer(
        child: _buildButton(
          context,
          title: LocaleKeys.maintenanceExecuteWork.tr(),
          onPressed: () async {
            final result = await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => BlocProvider(
                create: (context) => di.sl<OwnerExecuteMaintenanceCubit>(),
                child: OwnerExecuteMaintenanceBottomSheet(
                  maintenanceRequest: displayItem,
                ),
              ),
            );

            if (result != null && context.mounted) {
              onModified(true);
              context
                  .read<OwnerMaintenanceDetailsCubit>()
                  .getMaintenanceDetails(displayItem.safeId);

              if (result is ExecuteOwnerMaintenanceResponseEntity) {
                showDialog(
                  context: context,
                  builder: (context) =>
                      OwnerQaCodeDialog(qaCode: result.qaCode),
                );
              }
            }
          },
        ),
      );
    } else if (displayItem.canVerifyClose) {
      return _ActionBarContainer(
        child: _buildButton(
          context,
          title: LocaleKeys.maintenanceVerifyCloseSubmit.tr(),
          onPressed: () async {
            final result = await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => BlocProvider(
                create: (context) => di.sl<OwnerVerifyCloseMaintenanceCubit>(),
                child: OwnerVerifyCloseMaintenanceBottomSheet(
                  maintenanceRequest: displayItem,
                ),
              ),
            );

            if (result == true && context.mounted) {
              onModified(true);
              context
                  .read<OwnerMaintenanceDetailsCubit>()
                  .getMaintenanceDetails(displayItem.safeId);
            }
          },
        ),
      );
    } else if (displayItem.canForward) {
      return _ActionBarContainer(
        child: _buildButton(
          context,
          title: LocaleKeys.maintenanceForwardBtn.tr(),
          onPressed: () async {
            final result = await MaintenanceActionSheetsHelper.showForwardBottomSheet(
              context,
              displayItem.safeId,
            );
            if (result == true && context.mounted) {
              onModified(true);
              context
                  .read<OwnerMaintenanceDetailsCubit>()
                  .getMaintenanceDetails(displayItem.safeId);
            }
          },
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildButton(
    BuildContext context, {
    required String title,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: context.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.circularLg),
        elevation: 0,
      ),
      child: Text(
        title,
        style: AppTextStyles.h4.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _ActionBarContainer extends StatelessWidget {
  final Widget child;

  const _ActionBarContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(child: child),
    );
  }
}
