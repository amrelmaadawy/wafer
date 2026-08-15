import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/remove_task_assignee_usecase.dart';
import 'remove_task_assignee_state.dart';

class RemoveTaskAssigneeCubit extends Cubit<RemoveTaskAssigneeState> {
  final RemoveTaskAssigneeUseCase removeTaskAssigneeUseCase;

  RemoveTaskAssigneeCubit({required this.removeTaskAssigneeUseCase}) : super(RemoveTaskAssigneeInitial());

  Future<void> removeAssignee(int taskId, int assigneeId) async {
    emit(RemoveTaskAssigneeLoading(assigneeId: assigneeId));
    final result = await removeTaskAssigneeUseCase(
      RemoveTaskAssigneeParams(taskId: taskId, assigneeId: assigneeId),
    );

    result.fold(
      (failure) => emit(RemoveTaskAssigneeError(message: failure.message)),
      (task) => emit(RemoveTaskAssigneeSuccess(task: task)),
    );
  }
}
