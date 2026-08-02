import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/legal_cases_repository.dart';

class DeleteLegalCaseStageUseCase implements UseCase<void, DeleteStageParams> {
  final LegalCasesRepository repository;

  DeleteLegalCaseStageUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteStageParams params) async {
    return await repository.deleteLegalCaseStage(
      legalCaseId: params.legalCaseId,
      stageId: params.stageId,
    );
  }
}

class DeleteStageParams extends Equatable {
  final int legalCaseId;
  final int stageId;

  const DeleteStageParams({required this.legalCaseId, required this.stageId});

  @override
  List<Object?> get props => [legalCaseId, stageId];
}
