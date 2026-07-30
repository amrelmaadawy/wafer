import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/occupancy_report_entity.dart';
import '../repositories/owner_reports_repository.dart';

class GetOwnerOccupancyReportUseCase {
  final OwnerReportsRepository repository;

  GetOwnerOccupancyReportUseCase(this.repository);

  Future<Either<Failure, OccupancyReportEntity>> call({
    bool forceRefresh = false,
    int page = 1,
  }) async {
    return await repository.getOccupancyReport(
      forceRefresh: forceRefresh,
      page: page,
    );
  }
}
