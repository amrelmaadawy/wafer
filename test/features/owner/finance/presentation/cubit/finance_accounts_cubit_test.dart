import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:wafer/core/error/failures.dart';
import 'package:wafer/features/owner/finance/domain/entities/finance_account_entity.dart';
import 'package:wafer/features/owner/finance/domain/entities/finance_account_type.dart';
import 'package:wafer/features/owner/finance/domain/entities/finance_accounts_query_entity.dart';
import 'package:wafer/features/owner/finance/domain/usecases/get_finance_accounts_use_case.dart';
import 'package:wafer/features/owner/finance/presentation/cubit/accounts/finance_accounts_cubit.dart';
import 'package:wafer/features/owner/finance/presentation/cubit/accounts/finance_accounts_state.dart';
import 'package:wafer/features/owner/finance/domain/entities/finance_accounts_response_entity.dart';

class MockGetFinanceAccountsUseCase extends Mock implements GetFinanceAccountsUseCase {}

void main() {
  late FinanceAccountsCubit cubit;
  late MockGetFinanceAccountsUseCase mockUseCase;

  setUpAll(() {
    registerFallbackValue(const FinanceAccountsQueryEntity());
  });

  setUp(() {
    mockUseCase = MockGetFinanceAccountsUseCase();
    cubit = FinanceAccountsCubit(mockUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  final tAccount = FinanceAccountEntity(
    id: 1,
    code: '101',
    nameAr: 'Test',
    nameEn: 'Test',
    type: FinanceAccountType.asset,
    isPostable: true,
    level: 1,
    isActive: true,
  );

  final tResponse = FinanceAccountsResponseEntity(
    accounts: [tAccount],
    pagination: const FinancePaginationEntity(
      currentPage: 1,
      lastPage: 1,
      perPage: 15,
      total: 1,
      from: 1,
      to: 1,
    ),
  );

  group('FinanceAccountsCubit', () {
    test('initial state should be FinanceAccountsInitial', () {
      expect(cubit.state, isA<FinanceAccountsInitial>());
    });

    blocTest<FinanceAccountsCubit, FinanceAccountsState>(
      'should emit [Loading, Success] when fetch is successful',
      build: () {
        when(() => mockUseCase(any())).thenAnswer((_) async => Right(tResponse));
        return cubit;
      },
      act: (cubit) => cubit.fetchAccounts(),
      expect: () => [
        isA<FinanceAccountsLoading>(),
        isA<FinanceAccountsSuccess>().having((s) => s.accounts, 'accounts', [tAccount]),
      ],
    );

    blocTest<FinanceAccountsCubit, FinanceAccountsState>(
      'should emit [Loading, Error] when fetch fails',
      build: () {
        when(() => mockUseCase(any())).thenAnswer((_) async => Left(ServerFailure('Error')));
        return cubit;
      },
      act: (cubit) => cubit.fetchAccounts(),
      expect: () => [
        isA<FinanceAccountsLoading>(),
        isA<FinanceAccountsError>().having((s) => s.message, 'message', 'Error'),
      ],
    );
  });
}
