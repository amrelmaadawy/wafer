import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/employee_tasks_report_entity.dart';
import '../repositories/owner_reports_repository.dart';

class GetOwnerEmployeeTasksReportUseCase {
  final OwnerReportsRepository repository;

  GetOwnerEmployeeTasksReportUseCase(this.repository);

  Future<Either<Failure, EmployeeTasksReportEntity>> call({
    bool forceRefresh = false,
    int page = 1,
  }) async {
    return await repository.getEmployeeTasksReport(
      forceRefresh: forceRefresh,
      page: page,
    );
  }
}
