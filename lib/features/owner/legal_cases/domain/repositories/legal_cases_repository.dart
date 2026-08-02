import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/legal_case_form_data_entity.dart';
import '../entities/legal_cases_list_response_entity.dart';
import '../entities/legal_case_item_entity.dart';
import '../usecases/create_legal_case_use_case.dart';
import '../usecases/update_legal_case_use_case.dart';
import '../usecases/add_legal_case_stage_use_case.dart';

abstract class LegalCasesRepository {
  Future<Either<Failure, LegalCaseFormDataEntity>> getLegalCaseFormData();
  Future<Either<Failure, LegalCasesListResponseEntity>> getLegalCasesList({
    int page = 1,
    int perPage = 15,
    String? status,
  });
  Future<Either<Failure, LegalCaseItemEntity>> getLegalCaseDetails(int id);
  Future<Either<Failure, LegalCaseItemEntity>> createLegalCase(
      CreateLegalCaseParams params);
  Future<Either<Failure, LegalCaseItemEntity>> updateLegalCase(
      UpdateLegalCaseParams params);
  Future<Either<Failure, void>> deleteLegalCase(int id);
  Future<Either<Failure, LegalCaseItemEntity>> addLegalCaseStage(AddStageParams params);
  Future<Either<Failure, void>> deleteLegalCaseStage({required int legalCaseId, required int stageId});
}
