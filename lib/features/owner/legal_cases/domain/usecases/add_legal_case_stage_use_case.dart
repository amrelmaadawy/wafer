import 'package:dartz/dartz.dart';
import 'package:wafer/core/usecases/usecase.dart';

import '../../../../../../core/error/failures.dart';
import '../entities/legal_case_item_entity.dart';
import '../repositories/legal_cases_repository.dart';

class AddLegalCaseStageUseCase implements UseCase<LegalCaseItemEntity, AddStageParams> {
  final LegalCasesRepository repository;

  AddLegalCaseStageUseCase(this.repository);

  @override
  Future<Either<Failure, LegalCaseItemEntity>> call(AddStageParams params) async {
    return await repository.addLegalCaseStage(params);
  }
}

class AddStageParams {
  final int legalCaseId;
  final String stageName;
  final String stageDate;
  final String? notes;

  AddStageParams({
    required this.legalCaseId,
    required this.stageName,
    required this.stageDate,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'stage_name': stageName,
      'stage_date': stageDate,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
    };
  }
}
