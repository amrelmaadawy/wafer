import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:wafer/core/error/failures.dart';
import 'package:wafer/features/owner/search/domain/entities/search_results_grouped_entity.dart';
import 'package:wafer/features/owner/search/domain/entities/search_result_entity.dart';
import 'package:wafer/features/owner/search/domain/usecases/global_search_use_case.dart';
import 'package:wafer/features/owner/search/presentation/cubit/search_cubit.dart';
import 'package:wafer/features/owner/search/presentation/cubit/search_state.dart';

class MockGlobalSearchUseCase extends Mock implements GlobalSearchUseCase {}

void main() {
  late SearchCubit cubit;
  late MockGlobalSearchUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGlobalSearchUseCase();
    cubit = SearchCubit(searchUseCase: mockUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  const tQuery = 'test query';
  const tEmptyResults = SearchResultsGroupedEntity();
  const tResults = SearchResultsGroupedEntity(
    properties: [
      SearchResultEntity(id: 1, type: SearchResultType.property, title: 'Prop 1'),
    ],
  );

  test('initial state should be SearchInitial', () {
    expect(cubit.state, equals(const SearchInitial()));
  });

  test('onQueryChanged should emit SearchInitial if query length < 2', () {
    cubit.onQueryChanged('a');
    expect(cubit.state, equals(const SearchInitial()));
  });

  test('onQueryChanged should call use case and emit Loading then Loaded on success', () async {
    when(() => mockUseCase.call(any())).thenAnswer((_) async => const Right(tResults));

    cubit.onQueryChanged(tQuery);

    // Wait for debounce
    await Future.delayed(const Duration(milliseconds: 500));

    verify(() => mockUseCase.call(tQuery)).called(1);
    expect(cubit.state, equals(const SearchLoaded(results: tResults, query: tQuery)));
  });

  test('onQueryChanged should call use case and emit Empty if results are empty', () async {
    when(() => mockUseCase.call(any())).thenAnswer((_) async => const Right(tEmptyResults));

    cubit.onQueryChanged(tQuery);

    await Future.delayed(const Duration(milliseconds: 500));

    expect(cubit.state, equals(const SearchEmpty(query: tQuery)));
  });

  test('onQueryChanged should emit Error on failure', () async {
    when(() => mockUseCase.call(any())).thenAnswer((_) async => const Left(ServerFailure('Error')));

    cubit.onQueryChanged(tQuery);

    await Future.delayed(const Duration(milliseconds: 500));

    expect(cubit.state, equals(const SearchError(message: 'Error')));
  });

  test('clearSearch should emit SearchInitial', () {
    cubit.clearSearch();
    expect(cubit.state, equals(const SearchInitial()));
  });
}
