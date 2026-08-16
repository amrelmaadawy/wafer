import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/core/error/failures.dart';
import 'package:wafer/features/owner/finance/domain/entities/unified_transaction_entity.dart';
import 'package:wafer/features/owner/finance/domain/entities/unified_transactions_query_entity.dart';
import 'package:wafer/features/owner/finance/domain/usecases/get_unified_transactions_use_case.dart';
import 'package:wafer/features/owner/finance/presentation/cubit/transactions/unified_transactions_cubit.dart';
import 'package:wafer/features/owner/finance/presentation/cubit/transactions/unified_transactions_state.dart';

import 'package:wafer/features/owner/finance/domain/repositories/finance_repository.dart';

class FakeGetUnifiedTransactionsUseCase implements GetUnifiedTransactionsUseCase {
  Either<Failure, List<UnifiedTransactionEntity>> result = const Right([]);

  @override
  late FinanceRepository repository;

  @override
  Future<Either<Failure, List<UnifiedTransactionEntity>>> call(UnifiedTransactionsQueryEntity query) async {
    return result;
  }
}

void main() {
  late UnifiedTransactionsCubit cubit;
  late FakeGetUnifiedTransactionsUseCase fakeUseCase;

  setUp(() {
    fakeUseCase = FakeGetUnifiedTransactionsUseCase();
    cubit = UnifiedTransactionsCubit(getUnifiedTransactionsUseCase: fakeUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  const testTransactions = [
    UnifiedTransactionEntity(
      id: 1,
      referenceNumber: 'REC-001',
      type: UnifiedTransactionType.receipt,
      date: '2026-08-16T10:00:00Z',
      amount: 5000,
      isPositive: true,
      status: 'confirmed',
    ),
    UnifiedTransactionEntity(
      id: 2,
      referenceNumber: 'PAY-001',
      type: UnifiedTransactionType.payment,
      date: '2026-08-16T12:00:00Z',
      amount: 1500,
      isPositive: false,
      status: 'confirmed',
    ),
    UnifiedTransactionEntity(
      id: 3,
      referenceNumber: 'REC-002',
      type: UnifiedTransactionType.receipt,
      date: '2026-08-15T09:00:00Z',
      amount: 3000,
      isPositive: true,
      status: 'confirmed',
    ),
  ];

  test('initial state should be UnifiedTransactionsInitial', () {
    expect(cubit.state, isA<UnifiedTransactionsInitial>());
  });

  test('should emit UnifiedTransactionsEmpty when empty', () async {
    fakeUseCase.result = const Right([]);

    await cubit.loadTransactions();

    expect(cubit.state, isA<UnifiedTransactionsEmpty>());
  });

  test('should emit UnifiedTransactionsLoaded with grouped dates and cashflow metrics', () async {
    fakeUseCase.result = const Right(testTransactions);

    await cubit.loadTransactions();

    expect(cubit.state, isA<UnifiedTransactionsLoaded>());
    final loaded = cubit.state as UnifiedTransactionsLoaded;
    expect(loaded.totalIncome, equals(8000));
    expect(loaded.totalExpense, equals(1500));
    expect(loaded.netFlow, equals(6500));
    expect(loaded.groupedTransactions.keys.length, equals(2));
    expect(loaded.groupedTransactions['2026-08-16']?.length, equals(2));
    expect(loaded.groupedTransactions['2026-08-15']?.length, equals(1));
  });
}
