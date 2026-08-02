import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/update_legal_case_use_case.dart';
import 'legal_case_update_state.dart';

class LegalCaseUpdateCubit extends Cubit<LegalCaseUpdateState> {
  final UpdateLegalCaseUseCase _updateLegalCaseUseCase;

  LegalCaseUpdateCubit(this._updateLegalCaseUseCase)
    : super(LegalCaseUpdateInitial());

  Future<void> updateLegalCase(UpdateLegalCaseParams params) async {
    emit(LegalCaseUpdateLoading());

    final result = await _updateLegalCaseUseCase(params);

    result.fold((failure) {
      emit(LegalCaseUpdateError(failure.message));
    }, (legalCase) => emit(LegalCaseUpdateSuccess(legalCase)));
  }
}
