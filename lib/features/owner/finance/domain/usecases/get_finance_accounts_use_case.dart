import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/finance_accounts_response_entity.dart';
import '../repositories/finance_repository.dart';

class GetFinanceAccountsUseCase {
  final FinanceRepository repository;

  GetFinanceAccountsUseCase(this.repository);

  Future<Either<Failure, FinanceAccountsResponseEntity>> call({
    int page = 1,
    int perPage = 15,
    String? search,
    String? accountType,
    bool? isActive,
    bool? isPostable,
  }) async {
    return await repository.getAccounts(
      page: page,
      perPage: perPage,
      search: search,
      accountType: accountType,
      isActive: isActive,
      isPostable: isPostable,
    );
  }
}
