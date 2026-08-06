import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_technician_form_data_use_case.dart';
import 'technician_form_data_state.dart';

class TechnicianFormDataCubit extends Cubit<TechnicianFormDataState> {
  final GetTechnicianFormDataUseCase _getTechnicianFormDataUseCase;

  TechnicianFormDataCubit(this._getTechnicianFormDataUseCase)
    : super(TechnicianFormDataInitial());

  Future<void> getFormData() async {
    emit(TechnicianFormDataLoading());

    final result = await _getTechnicianFormDataUseCase(const NoParams());

    result.fold(
      (failure) => emit(TechnicianFormDataError(failure.message)),
      (data) => emit(TechnicianFormDataSuccess(data)),
    );
  }
}
