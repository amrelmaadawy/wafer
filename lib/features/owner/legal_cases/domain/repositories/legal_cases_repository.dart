import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/legal_case_form_data_entity.dart';
import '../entities/legal_cases_list_response_entity.dart';
import '../entities/legal_case_item_entity.dart';

abstract class LegalCasesRepository {
  Future<Either<Failure, LegalCaseFormDataEntity>> getLegalCaseFormData();
  Future<Either<Failure, LegalCasesListResponseEntity>> getLegalCasesList({
    int page = 1,
    int perPage = 15,
    String? status,
  });
  Future<Either<Failure, LegalCaseItemEntity>> getLegalCaseDetails(int id);
}
