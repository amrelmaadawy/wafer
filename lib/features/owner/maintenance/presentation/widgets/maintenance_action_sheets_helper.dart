import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/approve_maintenance/owner_approve_maintenance_cubit.dart';
import '../cubit/reject_maintenance/owner_reject_maintenance_cubit.dart';
import '../cubit/forward_maintenance/owner_forward_maintenance_cubit.dart';
import 'owner_approve_maintenance_bottom_sheet.dart';
import 'owner_reject_maintenance_bottom_sheet.dart';
import 'owner_forward_maintenance_bottom_sheet.dart';

class MaintenanceActionSheetsHelper {
  static void showApproveBottomSheet(
    BuildContext parentContext,
    int maintenanceId,
  ) {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => BlocProvider.value(
        value: parentContext.read<OwnerApproveMaintenanceCubit>(),
        child: OwnerApproveMaintenanceBottomSheet(maintenanceId: maintenanceId),
      ),
    );
  }

  static void showRejectBottomSheet(
    BuildContext parentContext,
    int maintenanceId,
  ) {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => BlocProvider.value(
        value: parentContext.read<OwnerRejectMaintenanceCubit>(),
        child: OwnerRejectMaintenanceBottomSheet(maintenanceId: maintenanceId),
      ),
    );
  }

  static Future<bool?> showForwardBottomSheet(
    BuildContext parentContext,
    int maintenanceId,
  ) {
    return showModalBottomSheet<bool>(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BlocProvider.value(
          value: parentContext.read<OwnerForwardMaintenanceCubit>(),
          child: OwnerForwardMaintenanceBottomSheet(
            maintenanceId: maintenanceId,
          ),
        );
      },
    );
  }
}
