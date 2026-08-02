import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_legal_case_details_use_case.dart';
import 'legal_case_details_state.dart';

class LegalCaseDetailsCubit extends Cubit<LegalCaseDetailsState> {
  final GetLegalCaseDetailsUseCase getLegalCaseDetailsUseCase;

  LegalCaseDetailsCubit(this.getLegalCaseDetailsUseCase)
    : super(LegalCaseDetailsInitial());

  Future<void> fetchLegalCaseDetails(int id) async {
    emit(LegalCaseDetailsLoading());
    final result = await getLegalCaseDetailsUseCase(id);
    result.fold(
      (failure) => emit(LegalCaseDetailsError(message: failure.message)),
      (legalCase) => emit(LegalCaseDetailsLoaded(legalCase: legalCase)),
    );
  }
}
