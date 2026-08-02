import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wafer/features/owner/legal_cases/domain/usecases/delete_legal_case_stage_use_case.dart';
import 'legal_case_delete_stage_state.dart';

class LegalCaseDeleteStageCubit extends Cubit<LegalCaseDeleteStageState> {
  final DeleteLegalCaseStageUseCase _deleteLegalCaseStageUseCase;

  LegalCaseDeleteStageCubit({
    required DeleteLegalCaseStageUseCase deleteLegalCaseStageUseCase,
  })  : _deleteLegalCaseStageUseCase = deleteLegalCaseStageUseCase,
        super(LegalCaseDeleteStageInitial());

  Future<void> deleteStage({required int legalCaseId, required int stageId}) async {
    emit(LegalCaseDeleteStageLoading());
    final result = await _deleteLegalCaseStageUseCase(
      DeleteStageParams(legalCaseId: legalCaseId, stageId: stageId),
    );
    result.fold(
      (failure) => emit(LegalCaseDeleteStageError(failure.message)),
      (_) => emit(LegalCaseDeleteStageSuccess()),
    );
  }
}
