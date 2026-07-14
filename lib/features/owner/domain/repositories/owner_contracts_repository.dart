import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/contract_details_entity.dart';
import '../entities/contract_installment_entity.dart';
import '../entities/contracts_response_entity.dart';

abstract class OwnerContractsRepository {
  Future<Either<Failure, ContractsResponseEntity>> getContracts({
    int page = 1,
    String? status,
    bool forceRefresh = false,
  });

  Future<Either<Failure, ContractDetailsEntity>> getContractDetails(String id);

  Future<Either<Failure, List<ContractInstallmentEntity>>> getContractInstallments(String contractId);
}
