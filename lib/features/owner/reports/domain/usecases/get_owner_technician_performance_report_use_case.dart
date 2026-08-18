import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/technician_performance_report_entity.dart';
import '../repositories/owner_reports_repository.dart';

class GetOwnerTechnicianPerformanceReportUseCase {
  final OwnerReportsRepository repository;

  GetOwnerTechnicianPerformanceReportUseCase(this.repository);

  Future<Either<Failure, TechnicianPerformanceReportEntity>> call({
    bool forceRefresh = false,
    int page = 1,
    String? startDate,
    String? endDate,
  }) async {
    return await repository.getTechnicianPerformanceReport(
      forceRefresh: forceRefresh,
      page: page,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
