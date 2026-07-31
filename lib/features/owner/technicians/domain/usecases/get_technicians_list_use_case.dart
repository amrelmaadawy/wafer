import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/technicians_list_response_entity.dart';
import '../repositories/technicians_repository.dart';

class GetTechniciansListUseCase
    implements UseCase<TechniciansListResponseEntity, GetTechniciansListParams> {
  final TechniciansRepository repository;

  GetTechniciansListUseCase(this.repository);

  @override
  Future<Either<Failure, TechniciansListResponseEntity>> call(
    GetTechniciansListParams params,
  ) {
    return repository.getTechniciansList(
      page: params.page,
      filters: params.filters,
    );
  }
}

class GetTechniciansListParams extends Equatable {
  final int page;
  final Map<String, dynamic>? filters;

  const GetTechniciansListParams({
    required this.page,
    this.filters,
  });

  @override
  List<Object?> get props => [page, filters];
}
