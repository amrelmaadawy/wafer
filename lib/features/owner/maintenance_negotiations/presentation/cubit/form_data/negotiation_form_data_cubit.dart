import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/get_negotiation_form_data_use_case.dart';
import 'negotiation_form_data_state.dart';

class NegotiationFormDataCubit extends Cubit<NegotiationFormDataState> {
  final GetNegotiationFormDataUseCase getFormDataUseCase;

  NegotiationFormDataCubit(this.getFormDataUseCase)
      : super(const NegotiationFormDataState());

  Future<void> getFormData() async {
    emit(state.copyWith(status: NegotiationFormDataStatus.loading));
    final result = await getFormDataUseCase(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
        status: NegotiationFormDataStatus.failure,
        errorMessage: failure.message,
      )),
      (formData) => emit(state.copyWith(
        status: NegotiationFormDataStatus.success,
        formData: formData,
      )),
    );
  }
}
