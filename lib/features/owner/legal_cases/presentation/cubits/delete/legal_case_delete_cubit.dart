import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/delete_legal_case_use_case.dart';
import 'legal_case_delete_state.dart';

class LegalCaseDeleteCubit extends Cubit<LegalCaseDeleteState> {
  final DeleteLegalCaseUseCase deleteLegalCaseUseCase;

  LegalCaseDeleteCubit(this.deleteLegalCaseUseCase)
    : super(LegalCaseDeleteInitial());

  Future<void> deleteLegalCase(int id) async {
    emit(LegalCaseDeleteLoading());
    final result = await deleteLegalCaseUseCase(id);
    result.fold(
      (failure) => emit(LegalCaseDeleteError(failure.message)),
      (_) => emit(LegalCaseDeleteSuccess()),
    );
  }
}
