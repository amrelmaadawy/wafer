import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/add_task_assignee_usecase.dart';
import 'add_task_assignee_state.dart';

class AddTaskAssigneeCubit extends Cubit<AddTaskAssigneeState> {
  final AddTaskAssigneeUseCase addTaskAssigneeUseCase;

  AddTaskAssigneeCubit({required this.addTaskAssigneeUseCase}) : super(AddTaskAssigneeInitial());

  Future<void> addAssignee(int taskId, int userId) async {
    emit(AddTaskAssigneeLoading());
    final result = await addTaskAssigneeUseCase(
      AddTaskAssigneeParams(taskId: taskId, userId: userId),
    );

    result.fold(
      (failure) => emit(AddTaskAssigneeError(message: failure.message)),
      (task) => emit(AddTaskAssigneeSuccess(task: task)),
    );
  }
}
