import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../domain/entities/maintenance_item_entity.dart';
import '../cubit/delete_maintenance/owner_delete_maintenance_cubit.dart';
import '../cubit/delete_maintenance/owner_delete_maintenance_state.dart';

class MaintenanceDeleteConfirmationSheet extends StatelessWidget {
  final MaintenanceItemEntity item;
  final OwnerDeleteMaintenanceCubit deleteCubit;

  const MaintenanceDeleteConfirmationSheet({
    super.key,
    required this.item,
    required this.deleteCubit,
  });

  static void show(BuildContext context, MaintenanceItemEntity item) {
    final deleteCubit = context.read<OwnerDeleteMaintenanceCubit>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.topXxl),
      builder: (bottomSheetContext) {
        return MaintenanceDeleteConfirmationSheet(
          item: item,
          deleteCubit: deleteCubit,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: deleteCubit,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.borderLight,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 24),
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.error,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              LocaleKeys.maintenanceDeleteConfirmTitle.tr(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              LocaleKeys.maintenanceDeleteConfirmDesc.tr(),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondaryLight,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadius.circularXl,
                      ),
                      side: const BorderSide(color: AppColors.borderLight),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      LocaleKeys.maintenanceDeleteCancelBtn.tr(),
                      style: const TextStyle(
                        color: AppColors.textPrimaryLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BlocBuilder<OwnerDeleteMaintenanceCubit, OwnerDeleteMaintenanceState>(
                    bloc: deleteCubit,
                    builder: (context, state) {
                      final isLoading = state.status == DeleteMaintenanceStatus.loading;
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: AppRadius.circularXl,
                          ),
                          elevation: 0,
                        ),
                        onPressed: isLoading
                            ? null
                            : () {
                                deleteCubit.deleteMaintenanceRequest(
                                  item.safeId,
                                );
                              },
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                LocaleKeys.maintenanceDeleteConfirmBtn.tr(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
