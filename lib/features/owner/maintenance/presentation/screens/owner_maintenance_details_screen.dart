import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/di/service_locator.dart' as di;
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../domain/entities/maintenance_item_entity.dart';
import '../cubit/approve_maintenance/owner_approve_maintenance_cubit.dart';
import '../cubit/approve_maintenance/owner_approve_maintenance_state.dart';
import '../cubit/complete_task/owner_complete_task_cubit.dart';
import '../cubit/delete_maintenance/owner_delete_maintenance_cubit.dart';
import '../cubit/delete_maintenance/owner_delete_maintenance_state.dart';
import '../cubit/details/owner_maintenance_details_cubit.dart';
import '../cubit/forward_maintenance/owner_forward_maintenance_cubit.dart';
import '../cubit/reject_maintenance/owner_reject_maintenance_cubit.dart';
import '../cubit/reject_maintenance/owner_reject_maintenance_state.dart';
import '../cubit/start_maintenance/owner_start_maintenance_cubit.dart';
import '../widgets/maintenance_details_view_content.dart';

class OwnerMaintenanceDetailsScreen extends StatefulWidget {
  final MaintenanceItemEntity item;

  const OwnerMaintenanceDetailsScreen({super.key, required this.item});

  @override
  State<OwnerMaintenanceDetailsScreen> createState() =>
      _OwnerMaintenanceDetailsScreenState();
}

class _OwnerMaintenanceDetailsScreenState
    extends State<OwnerMaintenanceDetailsScreen> {
  bool _isModified = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<OwnerMaintenanceDetailsCubit>()
            ..getMaintenanceDetails(widget.item.safeId),
        ),
        BlocProvider(create: (_) => di.sl<OwnerDeleteMaintenanceCubit>()),
        BlocProvider(create: (_) => di.sl<OwnerApproveMaintenanceCubit>()),
        BlocProvider(create: (_) => di.sl<OwnerRejectMaintenanceCubit>()),
        BlocProvider(create: (_) => di.sl<OwnerStartMaintenanceCubit>()),
        BlocProvider(create: (_) => di.sl<OwnerCompleteTaskCubit>()),
        BlocProvider(create: (_) => di.sl<OwnerForwardMaintenanceCubit>()),
      ],
      child: _DetailsListeners(
        onDeleted: () {
          AppToast.showSuccess(context, LocaleKeys.maintenanceDeleteSuccess.tr());
          context.pop(true);
        },
        onApproved: (msg) {
          AppToast.showSuccess(context, msg);
          context.pop(true);
        },
        onRejected: (msg) {
          AppToast.showSuccess(context, msg);
          context.pop(true);
        },
        child: MaintenanceDetailsViewContent(
          initialItem: widget.item,
          isModified: _isModified,
          onModifiedChanged: (val) {
            setState(() => _isModified = val);
          },
        ),
      ),
    );
  }
}

class _DetailsListeners extends StatelessWidget {
  final VoidCallback onDeleted;
  final ValueChanged<String> onApproved;
  final ValueChanged<String> onRejected;
  final Widget child;

  const _DetailsListeners({
    required this.onDeleted,
    required this.onApproved,
    required this.onRejected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OwnerDeleteMaintenanceCubit, OwnerDeleteMaintenanceState>(
          listener: (context, state) {
            if (state.status == DeleteMaintenanceStatus.success) {
              Navigator.of(context, rootNavigator: true).pop();
              onDeleted();
            } else if (state.status == DeleteMaintenanceStatus.failure) {
              Navigator.of(context, rootNavigator: true).pop();
              AppToast.showError(
                context,
                state.errorMessage ?? LocaleKeys.errorsServerError.tr(),
              );
            }
          },
        ),
        BlocListener<OwnerApproveMaintenanceCubit, OwnerApproveMaintenanceState>(
          listener: (context, state) {
            if (state is OwnerApproveMaintenanceSuccess) {
              Navigator.of(context, rootNavigator: true).pop();
              onApproved(state.message);
            } else if (state is OwnerApproveMaintenanceError) {
              AppToast.showError(context, state.message);
            }
          },
        ),
        BlocListener<OwnerRejectMaintenanceCubit, OwnerRejectMaintenanceState>(
          listener: (context, state) {
            if (state is OwnerRejectMaintenanceSuccess) {
              Navigator.of(context, rootNavigator: true).pop();
              onRejected(state.message);
            } else if (state is OwnerRejectMaintenanceError) {
              AppToast.showError(context, state.message);
            }
          },
        ),
      ],
      child: child,
    );
  }
}
