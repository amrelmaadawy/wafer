import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/contract_installment_entity.dart';
import '../repositories/owner_contracts_repository.dart';

class GetOwnerContractInstallmentsUseCase {
  final OwnerContractsRepository repository;

  GetOwnerContractInstallmentsUseCase(this.repository);

  Future<Either<Failure, List<ContractInstallmentEntity>>> call(String contractId) {
    return repository.getContractInstallments(contractId);
  }
}
