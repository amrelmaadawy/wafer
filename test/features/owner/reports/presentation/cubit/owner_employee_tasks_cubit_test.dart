import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wafer/core/error/failures.dart';
import 'package:wafer/features/owner/reports/domain/entities/employee_tasks_item_entity.dart';
import 'package:wafer/features/owner/reports/domain/entities/employee_tasks_report_entity.dart';
import 'package:wafer/features/owner/reports/domain/entities/employee_tasks_summary_entity.dart';
import 'package:wafer/features/owner/reports/domain/entities/maintenance_requests_report_entity.dart';
import 'package:wafer/features/owner/reports/domain/usecases/get_owner_employee_tasks_report_use_case.dart';
import 'package:wafer/features/owner/reports/presentation/cubit/owner_employee_tasks_cubit.dart';
import 'package:wafer/features/owner/reports/presentation/cubit/owner_employee_tasks_state.dart';

class _MockUseCase extends Mock implements GetOwnerEmployeeTasksReportUseCase {}

const _report = EmployeeTasksReportEntity(
  summary: EmployeeTasksSummaryEntity(
    totalEmployees: 1,
    totalCompleted: 4,
    totalPending: 2,
    totalOverdue: 1,
  ),
  items: [
    EmployeeTasksItemEntity(
      id: 1,
      name: 'Member',
      email: '',
      phone: '',
      completedTasks: 4,
      pendingTasks: 2,
      overdueTasks: 1,
    ),
  ],
  pagination: PaginationEntity(
    currentPage: 1,
    lastPage: 1,
    perPage: 15,
    total: 1,
  ),
);

void main() {
  late _MockUseCase useCase;
  setUp(() => useCase = _MockUseCase());

  blocTest<OwnerEmployeeTasksCubit, OwnerEmployeeTasksState>(
    'loads the confirmed workload report',
    build: () {
      when(
        () => useCase(forceRefresh: false, page: 1),
      ).thenAnswer((_) async => const Right(_report));
      return OwnerEmployeeTasksCubit(useCase);
    },
    act: (cubit) => cubit.fetchReport(),
    expect: () => [
      const OwnerEmployeeTasksLoading(isPagination: false),
      const OwnerEmployeeTasksLoaded(report: _report, hasReachedMax: true),
    ],
  );

  test('deduplicates concurrent report requests', () async {
    final completer = Completer<Either<Failure, EmployeeTasksReportEntity>>();
    when(
      () => useCase(forceRefresh: false, page: 1),
    ).thenAnswer((_) => completer.future);
    final cubit = OwnerEmployeeTasksCubit(useCase);

    final first = cubit.fetchReport();
    final second = cubit.fetchReport();
    completer.complete(const Right(_report));
    await Future.wait([first, second]);

    verify(() => useCase(forceRefresh: false, page: 1)).called(1);
    await cubit.close();
  });
}
