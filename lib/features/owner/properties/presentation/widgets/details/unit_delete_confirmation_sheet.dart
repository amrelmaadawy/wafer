import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/utils/widgets/app_toast.dart';
import '../../cubit/delete_unit/unit_delete_cubit.dart';
import '../../cubit/delete_unit/unit_delete_state.dart';

class UnitDeleteConfirmationSheet extends StatelessWidget {
  final int unitId;
  final UnitDeleteCubit deleteCubit;

  const UnitDeleteConfirmationSheet({
    super.key,
    required this.unitId,
    required this.deleteCubit,
  });

  static void show(BuildContext context, int unitId, UnitDeleteCubit deleteCubit) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.topXxl),
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: deleteCubit,
          child: UnitDeleteConfirmationSheet(
            unitId: unitId,
            deleteCubit: deleteCubit,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UnitDeleteCubit, UnitDeleteState>(
      listener: (context, state) {
        if (state is UnitDeleteSuccess) {
          Navigator.of(context).pop(); // Close sheet
          AppToast.showSuccess(context, 'delete_unit_success'.tr());
          context.pop(true); // Pop back to properties list
        } else if (state is UnitDeleteError) {
          AppToast.showError(context, state.message);
        }
      },
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
                borderRadius: AppRadius.circularLg,
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
              'delete_unit_title'.tr(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'delete_unit_desc'.tr(),
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
                      'cancel'.tr(),
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
                  child: BlocBuilder<UnitDeleteCubit, UnitDeleteState>(
                    builder: (context, state) {
                      final isLoading = state is UnitDeleteLoading;
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: const RoundedRectangleBorder(
                            borderRadius: AppRadius.circularXl,
                          ),
                          elevation: 0,
                        ),
                        onPressed: isLoading
                            ? null
                            : () {
                                deleteCubit.deleteUnit(unitId);
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
                                'delete'.tr(),
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

