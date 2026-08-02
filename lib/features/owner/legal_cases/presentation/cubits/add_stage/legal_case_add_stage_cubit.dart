import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wafer/features/owner/legal_cases/domain/usecases/add_legal_case_stage_use_case.dart';

import 'legal_case_add_stage_state.dart';

class LegalCaseAddStageCubit extends Cubit<LegalCaseAddStageState> {
  final AddLegalCaseStageUseCase addLegalCaseStageUseCase;

  LegalCaseAddStageCubit({
    required this.addLegalCaseStageUseCase,
  }) : super(LegalCaseAddStageInitial());

  Future<void> addStage({
    required int legalCaseId,
    required String stageName,
    required String stageDate,
    String? notes,
  }) async {
    emit(LegalCaseAddStageLoading());
    final result = await addLegalCaseStageUseCase(
      AddStageParams(
        legalCaseId: legalCaseId,
        stageName: stageName,
        stageDate: stageDate,
        notes: notes,
      ),
    );

    result.fold(
      (failure) => emit(LegalCaseAddStageError(failure.message)),
      (legalCase) => emit(LegalCaseAddStageSuccess(legalCase)),
    );
  }
}
