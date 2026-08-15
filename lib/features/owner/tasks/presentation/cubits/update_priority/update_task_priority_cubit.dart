import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/update_task_priority_usecase.dart';
import 'update_task_priority_state.dart';

class UpdateTaskPriorityCubit extends Cubit<UpdateTaskPriorityState> {
  final UpdateTaskPriorityUseCase updateTaskPriorityUseCase;

  UpdateTaskPriorityCubit({required this.updateTaskPriorityUseCase}) : super(UpdateTaskPriorityInitial());

  Future<void> updatePriority(int taskId, String priority) async {
    emit(UpdateTaskPriorityLoading());
    final result = await updateTaskPriorityUseCase(
      UpdateTaskPriorityParams(id: taskId, priority: priority),
    );

    result.fold(
      (failure) => emit(UpdateTaskPriorityError(message: failure.message)),
      (task) => emit(UpdateTaskPrioritySuccess(task: task)),
    );
  }
}
