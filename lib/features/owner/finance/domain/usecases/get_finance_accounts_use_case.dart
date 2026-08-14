import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/finance_accounts_response_entity.dart';
import '../repositories/finance_repository.dart';

import '../entities/finance_accounts_query_entity.dart';

class GetFinanceAccountsUseCase {
  final FinanceRepository repository;

  GetFinanceAccountsUseCase(this.repository);

  Future<Either<Failure, FinanceAccountsResponseEntity>> call(
    FinanceAccountsQueryEntity query,
  ) async {
    return await repository.getAccounts(query);
  }
}
