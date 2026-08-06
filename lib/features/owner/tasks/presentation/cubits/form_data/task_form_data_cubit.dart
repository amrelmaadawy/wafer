import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wafer/core/usecases/usecase.dart';
import '../../../domain/usecases/get_task_form_data_use_case.dart';
import 'task_form_data_state.dart';

class TaskFormDataCubit extends Cubit<TaskFormDataState> {
  final GetTaskFormDataUseCase getTaskFormDataUseCase;

  TaskFormDataCubit({required this.getTaskFormDataUseCase})
    : super(TaskFormDataInitial());

  Future<void> fetchFormData() async {
    emit(TaskFormDataLoading());
    final result = await getTaskFormDataUseCase(NoParams());
    result.fold(
      (failure) => emit(TaskFormDataError(failure.message)),
      (formData) => emit(TaskFormDataLoaded(formData)),
    );
  }
}
