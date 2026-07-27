import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/maintenance_requests_report_entity.dart';
import '../repositories/owner_reports_repository.dart';

class GetOwnerMaintenanceRequestsReportUseCase {
  final OwnerReportsRepository repository;

  GetOwnerMaintenanceRequestsReportUseCase(this.repository);

  Future<Either<Failure, MaintenanceRequestsReportEntity>> call({
    bool forceRefresh = false,
    int page = 1,
  }) async {
    return await repository.getMaintenanceRequestsReport(
      forceRefresh: forceRefresh,
      page: page,
    );
  }
}
