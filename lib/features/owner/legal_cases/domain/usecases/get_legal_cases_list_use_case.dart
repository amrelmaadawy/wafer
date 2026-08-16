import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/legal_cases_filter_params.dart';
import '../entities/legal_cases_list_response_entity.dart';
import '../repositories/legal_cases_repository.dart';

class GetLegalCasesListUseCase
    implements UseCase<LegalCasesListResponseEntity, LegalCasesFilterParams> {
  final LegalCasesRepository repository;

  GetLegalCasesListUseCase(this.repository);

  @override
  Future<Either<Failure, LegalCasesListResponseEntity>> call(
    LegalCasesFilterParams params,
  ) {
    return repository.getLegalCasesList(params: params);
  }
}
