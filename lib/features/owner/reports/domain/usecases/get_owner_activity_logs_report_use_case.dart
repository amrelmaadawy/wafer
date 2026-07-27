import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/activity_logs_report_entity.dart';
import '../repositories/owner_reports_repository.dart';

class GetOwnerActivityLogsReportUseCase {
  final OwnerReportsRepository repository;

  GetOwnerActivityLogsReportUseCase(this.repository);

  Future<Either<Failure, ActivityLogsReportEntity>> call({
    int page = 1,
    String? type,
    String? action,
  }) async {
    return await repository.getActivityLogsReport(
      page: page,
      type: type,
      action: action,
    );
  }
}
