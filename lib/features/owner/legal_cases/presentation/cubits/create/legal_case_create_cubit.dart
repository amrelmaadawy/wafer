import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/create_legal_case_use_case.dart';
import 'legal_case_create_state.dart';

class LegalCaseCreateCubit extends Cubit<LegalCaseCreateState> {
  final CreateLegalCaseUseCase createLegalCaseUseCase;

  LegalCaseCreateCubit(this.createLegalCaseUseCase)
    : super(LegalCaseCreateInitial());

  Future<void> createLegalCase(CreateLegalCaseParams params) async {
    emit(LegalCaseCreateLoading());
    final result = await createLegalCaseUseCase(params);
    result.fold(
      (failure) => emit(LegalCaseCreateError(failure.message)),
      (legalCase) => emit(LegalCaseCreateSuccess(legalCase)),
    );
  }
}
