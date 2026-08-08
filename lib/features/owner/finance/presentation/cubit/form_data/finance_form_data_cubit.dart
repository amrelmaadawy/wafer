import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_finance_form_data_use_case.dart';
import 'finance_form_data_state.dart';

class FinanceFormDataCubit extends Cubit<FinanceFormDataState> {
  final GetFinanceFormDataUseCase getFinanceFormDataUseCase;

  FinanceFormDataCubit(this.getFinanceFormDataUseCase) : super(FinanceFormDataInitial());

  Future<void> fetchFormData() async {
    emit(FinanceFormDataLoading());

    final result = await getFinanceFormDataUseCase();

    if (isClosed) return;

    result.fold(
      (failure) => emit(FinanceFormDataError(failure.message)),
      (formData) => emit(FinanceFormDataSuccess(formData)),
    );
  }
}
