import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/error/failures.dart';
import '../../../domain/entities/update_task_params.dart';
import '../../../domain/usecases/update_task_usecase.dart';
import 'update_task_state.dart';

class UpdateTaskCubit extends Cubit<UpdateTaskState> {
  final UpdateTaskUseCase _updateTaskUseCase;

  UpdateTaskCubit(this._updateTaskUseCase) : super(UpdateTaskInitial());

  Future<void> updateTask(UpdateTaskParams params) async {
    emit(UpdateTaskLoading());
    final result = await _updateTaskUseCase(params);
    result.fold(
      (failure) {
        final errs = failure is ServerFailure ? failure.validationErrors : null;
        emit(UpdateTaskFailure(failure.message, validationErrors: errs));
      },
      (task) => emit(UpdateTaskSuccess(task)),
    );
  }
}
