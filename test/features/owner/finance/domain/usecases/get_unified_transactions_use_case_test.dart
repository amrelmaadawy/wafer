import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/core/error/failures.dart';
import 'package:wafer/features/owner/finance/domain/entities/unified_transaction_entity.dart';
import 'package:wafer/features/owner/finance/domain/entities/unified_transactions_query_entity.dart';
import 'package:wafer/features/owner/finance/domain/repositories/finance_repository.dart';
import 'package:wafer/features/owner/finance/domain/usecases/get_unified_transactions_use_case.dart';

class FakeFinanceRepository implements FinanceRepository {
  List<UnifiedTransactionEntity> transactionsResult = [];

  @override
  Future<Either<Failure, List<UnifiedTransactionEntity>>> getUnifiedTransactions(
    UnifiedTransactionsQueryEntity query,
  ) async {
    return Right(transactionsResult);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late GetUnifiedTransactionsUseCase useCase;
  late FakeFinanceRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeFinanceRepository();
    useCase = GetUnifiedTransactionsUseCase(fakeRepository);
  });

  const query = UnifiedTransactionsQueryEntity(page: 1, limit: 15);
  const testTransactions = [
    UnifiedTransactionEntity(
      id: 1,
      referenceNumber: 'REC-001',
      type: UnifiedTransactionType.receipt,
      date: '2026-08-16',
      amount: 5000,
      isPositive: true,
      status: 'paid',
    ),
  ];

  test('should return list of unified transactions from repository', () async {
    fakeRepository.transactionsResult = testTransactions;

    final result = await useCase(query);

    expect(result, const Right(testTransactions));
  });
}
