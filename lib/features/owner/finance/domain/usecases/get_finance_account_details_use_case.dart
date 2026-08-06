import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/finance_account_entity.dart';
import '../repositories/finance_repository.dart';

class GetFinanceAccountDetailsUseCase {
  final FinanceRepository repository;

  GetFinanceAccountDetailsUseCase(this.repository);

  Future<Either<Failure, FinanceAccountEntity>> call(int id) async {
    return await repository.getAccountDetails(id);
  }
}
