import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:wafer/core/error/failures.dart';
import 'package:wafer/features/owner/finance/domain/entities/finance_overview_entity.dart';
import 'package:wafer/features/owner/finance/domain/usecases/get_finance_overview_usecase.dart';
import 'package:wafer/features/owner/finance/presentation/cubit/finance_overview_cubit.dart';
import 'package:wafer/features/owner/finance/presentation/cubit/finance_overview_state.dart';

class MockGetFinanceOverviewUseCase extends Mock
    implements GetFinanceOverviewUseCase {}

void main() {
  late FinanceOverviewCubit cubit;
  late MockGetFinanceOverviewUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetFinanceOverviewUseCase();
    cubit = FinanceOverviewCubit(getFinanceOverviewUseCase: mockUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  const tOverview = FinanceOverviewEntity(
    summary: FinanceSummaryEntity(
      receiptsTotal: 100000,
      paymentsTotal: 25000,
      netCashFlow: 75000,
      pendingReceipts: 2,
      pendingPayments: 1,
      pendingTransfers: 0,
      postedJournalEntries: 5,
    ),
    resources: {},
  );

  test('initial state should be FinanceOverviewInitial', () {
    expect(cubit.state, equals(FinanceOverviewInitial()));
  });

  blocTest<FinanceOverviewCubit, FinanceOverviewState>(
    'emits [Loading, Loaded] on successful fetchFinanceOverview',
    build: () {
      when(() => mockUseCase()).thenAnswer(
        (_) async => const Right(tOverview),
      );
      return cubit;
    },
    act: (cubit) => cubit.fetchFinanceOverview(),
    expect: () => [
      FinanceOverviewLoading(),
      FinanceOverviewLoaded(overview: tOverview),
    ],
  );

  blocTest<FinanceOverviewCubit, FinanceOverviewState>(
    'emits [Loading, Error] on failed fetchFinanceOverview',
    build: () {
      when(() => mockUseCase()).thenAnswer(
        (_) async => const Left(ServerFailure('Finance error')),
      );
      return cubit;
    },
    act: (cubit) => cubit.fetchFinanceOverview(),
    expect: () => [
      FinanceOverviewLoading(),
      FinanceOverviewError(message: 'Finance error'),
    ],
  );

  blocTest<FinanceOverviewCubit, FinanceOverviewState>(
    'isRefresh=true does not emit Loading state while data loads',
    build: () {
      when(() => mockUseCase()).thenAnswer(
        (_) async => const Left(ServerFailure('error')),
      );
      return cubit;
    },
    seed: () => FinanceOverviewLoaded(overview: tOverview),
    act: (cubit) => cubit.fetchFinanceOverview(isRefresh: true),
    expect: () => [
      FinanceOverviewError(message: 'error'),
    ],
  );
}
