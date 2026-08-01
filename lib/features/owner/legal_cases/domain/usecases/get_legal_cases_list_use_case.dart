import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/legal_cases_list_response_entity.dart';
import '../repositories/legal_cases_repository.dart';

class GetLegalCasesListUseCase
    implements UseCase<LegalCasesListResponseEntity, GetLegalCasesListParams> {
  final LegalCasesRepository repository;

  GetLegalCasesListUseCase(this.repository);

  @override
  Future<Either<Failure, LegalCasesListResponseEntity>> call(
      GetLegalCasesListParams params) {
    return repository.getLegalCasesList(
      page: params.page,
      perPage: params.perPage,
      status: params.status,
    );
  }
}

class GetLegalCasesListParams extends Equatable {
  final int page;
  final int perPage;
  final String? status;

  const GetLegalCasesListParams({
    this.page = 1,
    this.perPage = 15,
    this.status,
  });

  @override
  List<Object?> get props => [page, perPage, status];
}
