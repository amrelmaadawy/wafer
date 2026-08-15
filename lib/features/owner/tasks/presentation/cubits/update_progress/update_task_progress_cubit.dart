import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/update_task_progress_usecase.dart';
import 'update_task_progress_state.dart';

class UpdateTaskProgressCubit extends Cubit<UpdateTaskProgressState> {
  final UpdateTaskProgressUseCase updateTaskProgressUseCase;

  UpdateTaskProgressCubit({required this.updateTaskProgressUseCase}) : super(UpdateTaskProgressInitial());

  Future<void> updateProgress(int taskId, int progress) async {
    emit(UpdateTaskProgressLoading());
    final result = await updateTaskProgressUseCase(UpdateTaskProgressParams(id: taskId, progress: progress));
    result.fold(
      (failure) => emit(UpdateTaskProgressError(failure.message)),
      (task) => emit(UpdateTaskProgressSuccess(task)),
    );
  }
}
