import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/finance_accounts_response_entity.dart';
import '../entities/finance_overview_entity.dart';

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
}
