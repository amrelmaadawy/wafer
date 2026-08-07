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
  }) async {
    return await repository.getApprovalsReport(
      forceRefresh: forceRefresh,
      page: page,
    );
  }
}
