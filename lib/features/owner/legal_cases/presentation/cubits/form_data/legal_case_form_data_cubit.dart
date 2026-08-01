import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/get_legal_case_form_data_use_case.dart';
import 'legal_case_form_data_state.dart';

class LegalCaseFormDataCubit extends Cubit<LegalCaseFormDataState> {
  final GetLegalCaseFormDataUseCase getFormDataUseCase;

  LegalCaseFormDataCubit({required this.getFormDataUseCase})
      : super(LegalCaseFormDataInitial());

  Future<void> fetchFormData() async {
    emit(LegalCaseFormDataLoading());

    final result = await getFormDataUseCase(NoParams());

    result.fold(
      (failure) => emit(LegalCaseFormDataError(message: failure.message)),
      (formData) => emit(LegalCaseFormDataLoaded(formData: formData)),
    );
  }
}
