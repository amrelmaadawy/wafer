import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../domain/business_rules/task_business_rules.dart';
import '../../../domain/usecases/update_task_status_usecase.dart';
import 'update_task_status_state.dart';

class UpdateTaskStatusCubit extends Cubit<UpdateTaskStatusState> {
  final UpdateTaskStatusUseCase updateTaskStatusUseCase;

  UpdateTaskStatusCubit({required this.updateTaskStatusUseCase})
      : super(UpdateTaskStatusInitial());

  Future<void> updateStatus(
    int taskId,
    String status, {
    String? currentStatus,
  }) async {
    if (currentStatus != null) {
      final violation = TaskBusinessRules.validateTransition(currentStatus, status);
      if (violation != null) {
        emit(UpdateTaskStatusError(violation.messageKey.tr()));
        return;
      }
    }

    emit(UpdateTaskStatusLoading());

    final result = await updateTaskStatusUseCase(taskId, status);

    result.fold(
      (failure) => emit(UpdateTaskStatusError(failure.message)),
      (task) => emit(UpdateTaskStatusSuccess(task)),
    );
  }
}
