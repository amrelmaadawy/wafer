import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/get_supervisor_form_data_use_case.dart';
import 'supervisor_form_data_state.dart';

class SupervisorFormDataCubit extends Cubit<SupervisorFormDataState> {
  final GetSupervisorFormDataUseCase getSupervisorFormDataUseCase;

  SupervisorFormDataCubit(this.getSupervisorFormDataUseCase)
      : super(SupervisorFormDataInitial());

  Future<void> getFormData() async {
    emit(SupervisorFormDataLoading());
    final result = await getSupervisorFormDataUseCase(NoParams());
    result.fold(
      (failure) => emit(SupervisorFormDataError(failure.message)),
      (data) => emit(SupervisorFormDataSuccess(data)),
    );
  }
}
