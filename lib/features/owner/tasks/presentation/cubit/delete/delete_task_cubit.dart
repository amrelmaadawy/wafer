import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/error/failures.dart';
import '../../../domain/use_cases/delete_task_use_case.dart';
import 'delete_task_state.dart';

class DeleteTaskCubit extends Cubit<DeleteTaskState> {
  final DeleteTaskUseCase _deleteTaskUseCase;

  DeleteTaskCubit(this._deleteTaskUseCase) : super(DeleteTaskInitial());

  Future<void> deleteTask(int id) async {
    emit(DeleteTaskLoading());
    final result = await _deleteTaskUseCase(id: id);

    result.fold(
      (failure) => emit(DeleteTaskError(_mapFailureToMessage(failure))),
      (_) => emit(DeleteTaskSuccess()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    }
    return 'Unexpected Error';
  }
}
