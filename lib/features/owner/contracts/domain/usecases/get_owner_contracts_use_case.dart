import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/contracts_response_entity.dart';
import '../entities/contract_status_filter.dart';
import '../repositories/owner_contracts_repository.dart';

class GetOwnerContractsParams extends Equatable {
  final int page;
  final ContractStatusFilter status;
  final bool forceRefresh;

  const GetOwnerContractsParams({
    this.page = 1,
    this.status = ContractStatusFilter.all,
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [page, status, forceRefresh];
}

class GetOwnerContractsUseCase
    implements UseCase<ContractsResponseEntity, GetOwnerContractsParams> {
  final OwnerContractsRepository _repository;

  GetOwnerContractsUseCase(this._repository);

  @override
  Future<Either<Failure, ContractsResponseEntity>> call(
    GetOwnerContractsParams params,
  ) {
    return _repository.getContracts(
      page: params.page,
      status: params.status,
      forceRefresh: params.forceRefresh,
    );
  }
}
