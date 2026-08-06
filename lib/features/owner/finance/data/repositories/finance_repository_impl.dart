import 'package:dartz/dartz.dart';
import '../../../../../core/data/base_repository.dart';
import '../../../../../core/error/failures.dart';

import '../../domain/entities/finance_accounts_response_entity.dart';
import '../../domain/entities/finance_overview_entity.dart';
import '../../domain/repositories/finance_repository.dart';
import '../datasources/finance_remote_data_source.dart';

class FinanceRepositoryImpl extends BaseRepository
    implements FinanceRepository {
  final FinanceRemoteDataSource remoteDataSource;

  FinanceRepositoryImpl({
    required this.remoteDataSource,
    required super.networkInfo,
  });

  @override
  Future<Either<Failure, FinanceOverviewEntity>> getFinanceOverview() async {
    return executeApiCall<FinanceOverviewEntity>(
      call: () => remoteDataSource.getFinanceOverview(),
    );
  }

  @override
  Future<Either<Failure, FinanceAccountsResponseEntity>> getAccounts({
    int page = 1,
    int perPage = 15,
    String? search,
    String? accountType,
    bool? isActive,
    bool? isPostable,
  }) async {
    return executeApiCall<FinanceAccountsResponseEntity>(
      call: () => remoteDataSource.getAccounts(
        page: page,
        perPage: perPage,
        search: search,
        accountType: accountType,
        isActive: isActive,
        isPostable: isPostable,
      ),
    );
  }
}
