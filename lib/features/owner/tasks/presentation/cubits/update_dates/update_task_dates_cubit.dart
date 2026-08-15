import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/update_task_dates_usecase.dart';
import 'update_task_dates_state.dart';

class UpdateTaskDatesCubit extends Cubit<UpdateTaskDatesState> {
  final UpdateTaskDatesUseCase updateTaskDatesUseCase;

  UpdateTaskDatesCubit({required this.updateTaskDatesUseCase}) : super(UpdateTaskDatesInitial());

  Future<void> updateDates(int taskId, {String? startDate, String? dueDate}) async {
    emit(UpdateTaskDatesLoading());
    final result = await updateTaskDatesUseCase(
      UpdateTaskDatesParams(id: taskId, startDate: startDate, dueDate: dueDate),
    );

    result.fold(
      (failure) => emit(UpdateTaskDatesError(message: failure.message)),
      (task) => emit(UpdateTaskDatesSuccess(task: task)),
    );
  }
}
