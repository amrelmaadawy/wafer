import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/utils/widgets/app_toast.dart';
import '../cubit/start_maintenance/owner_start_maintenance_cubit.dart';
import '../cubit/start_maintenance/owner_start_maintenance_state.dart';

class OwnerStartMaintenanceDialog extends StatelessWidget {
  final int maintenanceId;

  const OwnerStartMaintenanceDialog({super.key, required this.maintenanceId});

  static Future<bool?> show(BuildContext context, int maintenanceId) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<OwnerStartMaintenanceCubit>(),
        child: OwnerStartMaintenanceDialog(maintenanceId: maintenanceId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.circularXxl),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_circle_fill,
                color: context.primaryColor,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              LocaleKeys.maintenanceStartConfirmTitle.tr(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              LocaleKeys.maintenanceStartConfirmDesc.tr(),
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
                    onPressed: () => context.pop(),
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
                  child:
                      BlocConsumer<
                        OwnerStartMaintenanceCubit,
                        OwnerStartMaintenanceState
                      >(
                        listener: (context, state) {
                          if (state is OwnerStartMaintenanceSuccess) {
                            context.pop(true);
                          } else if (state is OwnerStartMaintenanceError) {
                            AppToast.showError(context, state.message);
                          }
                        },
                        builder: (context, state) {
                          final isLoading =
                              state is OwnerStartMaintenanceLoading;
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: const RoundedRectangleBorder(
                                borderRadius: AppRadius.circularXl,
                              ),
                              elevation: 0,
                            ),
                            onPressed: isLoading
                                ? null
                                : () {
                                    context
                                        .read<OwnerStartMaintenanceCubit>()
                                        .startMaintenanceRequest(maintenanceId);
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
                                    LocaleKeys.maintenanceStartSubmit.tr(),
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
