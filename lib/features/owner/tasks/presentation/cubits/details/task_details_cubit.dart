import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_task_details_usecase.dart';
import 'task_details_state.dart';

class TaskDetailsCubit extends Cubit<TaskDetailsState> {
  final GetTaskDetailsUseCase getTaskDetailsUseCase;

  TaskDetailsCubit(this.getTaskDetailsUseCase) : super(TaskDetailsInitial());

  Future<void> fetchTaskDetails(int id, {bool refresh = false}) async {
    if (!refresh) {
      emit(TaskDetailsLoading());
    }

    final result = await getTaskDetailsUseCase(id: id);

    result.fold(
      (failure) => emit(TaskDetailsError(failure.message)),
      (task) => emit(TaskDetailsLoaded(task)),
    );
  }
}
