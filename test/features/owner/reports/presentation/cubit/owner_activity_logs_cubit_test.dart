import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wafer/features/owner/reports/domain/entities/activity_logs_item_entity.dart';
import 'package:wafer/features/owner/reports/domain/entities/activity_logs_report_entity.dart';
import 'package:wafer/features/owner/reports/domain/entities/activity_logs_summary_entity.dart';
import 'package:wafer/features/owner/reports/domain/entities/activity_logs_user_entity.dart';
import 'package:wafer/features/owner/reports/domain/entities/report_pagination_entity.dart';
import 'package:wafer/features/owner/reports/domain/usecases/get_owner_activity_logs_report_use_case.dart';
import 'package:wafer/features/owner/reports/presentation/cubit/owner_activity_logs_cubit.dart';
import 'package:wafer/features/owner/reports/presentation/cubit/owner_activity_logs_state.dart';

class _MockUseCase extends Mock implements GetOwnerActivityLogsReportUseCase {}

const _summary = ActivityLogsSummaryEntity(
  totalLogs: 2,
  creates: 1,
  updates: 1,
  deletes: 0,
);
const _user = ActivityLogsUserEntity(id: 1, name: 'Owner', userType: 'owner');

ActivityLogsReportEntity _report(int page, int id, {bool empty = false}) =>
    ActivityLogsReportEntity(
      summary: _summary,
      items: empty
          ? const []
          : [
              ActivityLogsItemEntity(
                id: id,
                createdAt: '',
                user: _user,
                type: 'property',
                action: 'update',
                message: 'Updated',
                ipAddress: '',
              ),
            ],
      pagination: ReportPaginationEntity(
        currentPage: page,
        lastPage: 2,
        perPage: 1,
        total: 2,
        from: page,
        to: page,
      ),
      types: page == 1 ? const ['property'] : const [],
      actions: page == 1 ? const ['update'] : const [],
    );

void main() {
  late _MockUseCase useCase;
  setUp(() => useCase = _MockUseCase());

  blocTest<OwnerActivityLogsCubit, OwnerActivityLogsState>(
    'preserves typed content and filter options during pagination',
    build: () {
      when(
        () => useCase(page: 1, type: null, action: null),
      ).thenAnswer((_) async => Right(_report(1, 1)));
      when(
        () => useCase(page: 2, type: null, action: null),
      ).thenAnswer((_) async => Right(_report(2, 2)));
      return OwnerActivityLogsCubit(useCase);
    },
    act: (cubit) async {
      await cubit.fetchReport();
      await cubit.fetchReport();
    },
    verify: (cubit) {
      final state = cubit.state as OwnerActivityLogsLoaded;
      expect(state.report.items.map((item) => item.id), [1, 2]);
      expect(state.report.types, ['property']);
      expect(state.report.actions, ['update']);
    },
  );

  blocTest<OwnerActivityLogsCubit, OwnerActivityLogsState>(
    'sends confirmed filters and retains options for an empty result',
    build: () {
      when(
        () => useCase(page: 1, type: 'property', action: 'update'),
      ).thenAnswer((_) async => Right(_report(1, 0, empty: true)));
      return OwnerActivityLogsCubit(useCase);
    },
    act: (cubit) => cubit.setFilters(type: 'property', action: 'update'),
    expect: () => [
      const OwnerActivityLogsLoading(),
      OwnerActivityLogsEmpty(_report(1, 0, empty: true)),
    ],
  );
}
