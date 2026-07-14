import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/contracts_response_entity.dart';
import '../repositories/owner_contracts_repository.dart';

class GetOwnerContractsParams extends Equatable {
  final int page;
  final String? status;
  final bool forceRefresh;

  const GetOwnerContractsParams({
    this.page = 1,
    this.status,
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [page, status, forceRefresh];
}

class GetOwnerContractsUseCase implements UseCase<ContractsResponseEntity, GetOwnerContractsParams> {
  final OwnerContractsRepository _repository;

  GetOwnerContractsUseCase(this._repository);

  @override
  Future<Either<Failure, ContractsResponseEntity>> call(GetOwnerContractsParams params) {
    return _repository.getContracts(
      page: params.page,
      status: params.status,
      forceRefresh: params.forceRefresh,
    );
  }
}
