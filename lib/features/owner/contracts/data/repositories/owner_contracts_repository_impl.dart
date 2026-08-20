import 'package:dartz/dartz.dart';
import '../../../../../core/data/base_repository.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/contract_details_entity.dart';
import '../../domain/entities/contract_installment_entity.dart';
import '../../domain/entities/contracts_response_entity.dart';
import '../../domain/entities/contract_status_filter.dart';
import '../../domain/repositories/owner_contracts_repository.dart';
import '../datasources/owner_contracts_remote_data_source.dart';

class OwnerContractsRepositoryImpl extends BaseRepository
    implements OwnerContractsRepository {
  final OwnerContractsRemoteDataSource _remoteDataSource;

  OwnerContractsRepositoryImpl({
    required OwnerContractsRemoteDataSource remoteDataSource,
    required super.networkInfo,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, ContractsResponseEntity>> getContracts({
    int page = 1,
    ContractStatusFilter status = ContractStatusFilter.all,
    bool forceRefresh = false,
  }) async {
    return executeApiCall<ContractsResponseEntity>(
      call: () => _remoteDataSource.getContracts(page: page, status: status),
    );
  }

  @override
  Future<Either<Failure, ContractDetailsEntity>> getContractDetails(
    String id,
  ) async {
    return executeApiCall<ContractDetailsEntity>(
      call: () => _remoteDataSource.getContractDetails(id),
    );
  }

  @override
  Future<Either<Failure, ContractDetailsEntity>> updateContract({
    required String id,
    int? renewalNoticeDays,
    String? notes,
  }) async {
    return executeApiCall<ContractDetailsEntity>(
      call: () => _remoteDataSource.updateContract(
        id: id,
        renewalNoticeDays: renewalNoticeDays,
        notes: notes,
      ),
    );
  }

  @override
  Future<Either<Failure, List<ContractInstallmentEntity>>>
  getContractInstallments(String contractId) async {
    return executeApiCall<List<ContractInstallmentEntity>>(
      call: () => _remoteDataSource.getContractInstallments(contractId),
    );
  }
}
