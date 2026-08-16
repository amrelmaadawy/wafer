import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/error/failures.dart';
import '../../../domain/entities/create_task_params.dart';
import '../../../domain/usecases/create_task_usecase.dart';
import 'create_task_state.dart';

class CreateTaskCubit extends Cubit<CreateTaskState> {
  final CreateTaskUseCase createTaskUseCase;

  CreateTaskCubit({required this.createTaskUseCase})
      : super(CreateTaskInitial());

  Future<void> submitTask(CreateTaskParams params) async {
    emit(CreateTaskLoading());
    final result = await createTaskUseCase(params);
    result.fold(
      (failure) {
        final errs = failure is ServerFailure ? failure.validationErrors : null;
        emit(CreateTaskError(failure.message, validationErrors: errs));
      },
      (task) => emit(CreateTaskSuccess(task)),
    );
  }
}
