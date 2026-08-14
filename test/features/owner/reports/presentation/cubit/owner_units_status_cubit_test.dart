import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wafer/features/owner/reports/domain/entities/report_pagination_entity.dart';
import 'package:wafer/features/owner/reports/domain/entities/units_status_filter_options_entity.dart';
import 'package:wafer/features/owner/reports/domain/entities/units_status_report_entity.dart';
import 'package:wafer/features/owner/reports/domain/entities/units_status_summary_entity.dart';
import 'package:wafer/features/owner/reports/domain/usecases/get_owner_units_status_report_usecase.dart';
import 'package:wafer/features/owner/reports/presentation/cubit/owner_units_status_cubit.dart';
import 'package:wafer/features/owner/reports/presentation/cubit/owner_units_status_state.dart';

class _MockUseCase extends Mock implements GetOwnerUnitsStatusReportUseCase {}

const _filters = UnitsStatusFilterOptionsEntity(statuses: [], properties: []);

UnitsStatusReportEntity _report() => const UnitsStatusReportEntity(
  summary: UnitsStatusSummaryEntity(
    total: 0,
    vacant: 0,
    rented: 0,
    maintenance: 0,
  ),
  items: [],
  pagination: ReportPaginationEntity(
    currentPage: 1,
    lastPage: 1,
    perPage: 15,
    total: 0,
    from: 0,
    to: 0,
  ),
  filterOptions: _filters,
);

void main() {
  late _MockUseCase useCase;

  setUpAll(() => registerFallbackValue(GetOwnerUnitsStatusReportParams()));
  setUp(() => useCase = _MockUseCase());

  blocTest<OwnerUnitsStatusCubit, OwnerUnitsStatusState>(
    'loads a confirmed empty portfolio response',
    build: () {
      when(() => useCase(any())).thenAnswer((_) async => Right(_report()));
      return OwnerUnitsStatusCubit(useCase);
    },
    act: (cubit) => cubit.loadUnitsStatusReport(forceRefresh: true),
    expect: () => [
      const OwnerUnitsStatusLoading(),
      const OwnerUnitsStatusEmpty(filterOptions: _filters),
    ],
  );

  test('converts all-filter sentinels to null API parameters', () async {
    when(() => useCase(any())).thenAnswer((_) async => Right(_report()));
    final cubit = OwnerUnitsStatusCubit(useCase);

    await cubit.loadUnitsStatusReport(
      forceRefresh: true,
      propertyId: -1,
      status: 'ALL',
    );

    final captured =
        verify(() => useCase(captureAny())).captured.single
            as GetOwnerUnitsStatusReportParams;
    expect(captured.propertyId, isNull);
    expect(captured.status, isNull);
    await cubit.close();
  });
}
