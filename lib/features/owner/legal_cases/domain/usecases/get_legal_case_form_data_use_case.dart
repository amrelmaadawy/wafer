import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/legal_case_form_data_entity.dart';
import '../repositories/legal_cases_repository.dart';

class GetLegalCaseFormDataUseCase
    implements UseCase<LegalCaseFormDataEntity, NoParams> {
  final LegalCasesRepository repository;

  GetLegalCaseFormDataUseCase(this.repository);

  @override
  Future<Either<Failure, LegalCaseFormDataEntity>> call(NoParams params) {
    return repository.getLegalCaseFormData();
  }
}
