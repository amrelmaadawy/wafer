import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/contract_details_entity.dart';
import '../repositories/owner_contracts_repository.dart';

class GetOwnerContractDetailsUseCase implements UseCase<ContractDetailsEntity, String> {
  final OwnerContractsRepository _repository;

  GetOwnerContractDetailsUseCase(this._repository);

  @override
  Future<Either<Failure, ContractDetailsEntity>> call(String contractId) {
    return _repository.getContractDetails(contractId);
  }
}
