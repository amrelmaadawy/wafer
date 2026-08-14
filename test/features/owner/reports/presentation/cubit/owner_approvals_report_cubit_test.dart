import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wafer/features/owner/reports/domain/entities/approvals_report_entity.dart';
import 'package:wafer/features/owner/reports/domain/entities/maintenance_requests_report_entity.dart';
import 'package:wafer/features/owner/reports/domain/usecases/get_approvals_report_use_case.dart';
import 'package:wafer/features/owner/reports/presentation/cubit/owner_approvals_report_cubit.dart';
import 'package:wafer/features/owner/reports/presentation/cubit/owner_approvals_report_state.dart';

class _MockUseCase extends Mock implements GetApprovalsReportUseCase {}

const _summary = ApprovalsSummaryEntity(
  total: 2,
  approved: 0,
  pending: 2,
  rejected: 0,
);
const _filters = ApprovalsFilterOptionsEntity(
  statuses: [],
  approvableTypes: [],
  users: [],
  properties: [],
);

ApprovalsReportEntity _report(int page, int itemId) => ApprovalsReportEntity(
  summary: _summary,
  items: [ApprovalItemEntity(id: itemId, status: 'pending')],
  pagination: PaginationEntity(
    currentPage: page,
    lastPage: 2,
    perPage: 1,
    total: 2,
  ),
  filterOptions: _filters,
);

void main() {
  late _MockUseCase useCase;
  setUp(() => useCase = _MockUseCase());

  blocTest<OwnerApprovalsReportCubit, OwnerApprovalsReportState>(
    'preserves typed content while loading the next page',
    build: () {
      when(
        () => useCase(forceRefresh: false, page: 1),
      ).thenAnswer((_) async => Right(_report(1, 1)));
      when(
        () => useCase(forceRefresh: false, page: 2),
      ).thenAnswer((_) async => Right(_report(2, 2)));
      return OwnerApprovalsReportCubit(getApprovalsReportUseCase: useCase);
    },
    act: (cubit) async {
      await cubit.fetchReport();
      await cubit.fetchReport();
    },
    expect: () {
      final first = _report(1, 1);
      final merged = ApprovalsReportEntity(
        summary: _summary,
        items: const [
          ApprovalItemEntity(id: 1, status: 'pending'),
          ApprovalItemEntity(id: 2, status: 'pending'),
        ],
        pagination: _report(2, 2).pagination,
        filterOptions: _filters,
      );
      return [
        const OwnerApprovalsReportLoading(isFirstFetch: true),
        OwnerApprovalsReportLoaded(report: first, hasReachedMax: false),
        OwnerApprovalsReportLoading(isFirstFetch: false, report: first),
        OwnerApprovalsReportLoaded(report: merged, hasReachedMax: true),
      ];
    },
  );
}
