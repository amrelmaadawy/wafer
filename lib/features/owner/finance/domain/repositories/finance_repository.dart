import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/finance_account_entity.dart';
import '../entities/finance_accounts_response_entity.dart';
import '../entities/finance_overview_entity.dart';
import '../usecases/create_finance_account_use_case.dart';
import '../usecases/update_finance_account_use_case.dart';

abstract class FinanceRepository {
  Future<Either<Failure, FinanceOverviewEntity>> getFinanceOverview();

  Future<Either<Failure, FinanceAccountsResponseEntity>> getAccounts({
    int page = 1,
    int perPage = 15,
    String? search,
    String? accountType,
    bool? isActive,
    bool? isPostable,
  });

  Future<Either<Failure, FinanceAccountEntity>> createAccount(
    CreateFinanceAccountParams params,
  );

  Future<Either<Failure, FinanceAccountEntity>> updateAccount(
    UpdateFinanceAccountParams params,
  );
}
