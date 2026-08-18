import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/approvals_report_entity.dart';
import '../repositories/owner_reports_repository.dart';

class GetApprovalsReportUseCase {
  final OwnerReportsRepository repository;

  GetApprovalsReportUseCase(this.repository);

  Future<Either<Failure, ApprovalsReportEntity>> call({
    bool forceRefresh = false,
    int page = 1,
    String? status,
    String? startDate,
    String? endDate,
  }) async {
    return await repository.getApprovalsReport(
      forceRefresh: forceRefresh,
      page: page,
      status: status,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
