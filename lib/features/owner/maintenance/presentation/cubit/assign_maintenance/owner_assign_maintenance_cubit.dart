import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/error/failures.dart';
import '../../../domain/usecases/assign_owner_maintenance_use_case.dart';
import 'owner_assign_maintenance_state.dart';

class OwnerAssignMaintenanceCubit extends Cubit<OwnerAssignMaintenanceState> {
  final AssignOwnerMaintenanceUseCase assignMaintenanceUseCase;

  OwnerAssignMaintenanceCubit(this.assignMaintenanceUseCase)
    : super(OwnerAssignMaintenanceInitial());

  Future<void> assignMaintenanceRequest({
    required int id,
    required int technicianId,
    required String dueDate,
    required String taskDetails,
    required List<String> tasks,
  }) async {
    emit(OwnerAssignMaintenanceLoading());

    final params = AssignOwnerMaintenanceParams(
      id: id,
      technicianId: technicianId,
      dueDate: dueDate,
      taskDetails: taskDetails,
      tasks: tasks,
    );

    final result = await assignMaintenanceUseCase(params);

    result.fold(
      (failure) {
        String message = 'Failed to assign technician';
        if (failure is ServerFailure) {
          message = failure.message;
        }
        emit(OwnerAssignMaintenanceError(message));
      },
      (_) => emit(
        const OwnerAssignMaintenanceSuccess(
          'Maintenance request assigned successfully',
        ),
      ),
    );
  }
}
