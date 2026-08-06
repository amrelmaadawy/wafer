import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/complete_owner_maintenance_task_use_case.dart';
import 'owner_complete_task_state.dart';

class OwnerCompleteTaskCubit extends Cubit<OwnerCompleteTaskState> {
  final CompleteOwnerMaintenanceTaskUseCase _completeTaskUseCase;

  OwnerCompleteTaskCubit(this._completeTaskUseCase)
    : super(const OwnerCompleteTaskState());

  Future<void> completeTask({
    required int maintenanceId,
    required int taskId,
    required String technicianResponse,
  }) async {
    emit(state.copyWith(status: CompleteTaskStatus.loading));

    final params = CompleteOwnerMaintenanceTaskParams(
      maintenanceId: maintenanceId,
      taskId: taskId,
      technicianResponse: technicianResponse,
    );

    final result = await _completeTaskUseCase(params);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: CompleteTaskStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (item) {
        emit(state.copyWith(status: CompleteTaskStatus.success, item: item));
      },
    );
  }
}
