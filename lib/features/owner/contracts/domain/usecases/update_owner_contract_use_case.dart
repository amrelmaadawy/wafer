import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/contract_details_entity.dart';
import '../repositories/owner_contracts_repository.dart';

class UpdateOwnerContractUseCase {
  final OwnerContractsRepository repository;

  const UpdateOwnerContractUseCase(this.repository);

  Future<Either<Failure, ContractDetailsEntity>> call({
    required String id,
    int? renewalNoticeDays,
    String? notes,
  }) async {
    return repository.updateContract(
      id: id,
      renewalNoticeDays: renewalNoticeDays,
      notes: notes,
    );
  }
}
