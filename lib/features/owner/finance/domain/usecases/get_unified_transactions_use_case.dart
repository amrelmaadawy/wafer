import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/unified_transaction_entity.dart';
import '../entities/unified_transactions_query_entity.dart';
import '../repositories/finance_repository.dart';

class GetUnifiedTransactionsUseCase {
  final FinanceRepository repository;

  const GetUnifiedTransactionsUseCase(this.repository);

  Future<Either<Failure, List<UnifiedTransactionEntity>>> call(
    UnifiedTransactionsQueryEntity query,
  ) {
    return repository.getUnifiedTransactions(query);
  }
}
