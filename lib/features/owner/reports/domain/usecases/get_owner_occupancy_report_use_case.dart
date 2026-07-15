import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/occupancy_property_entity.dart';
import '../repositories/owner_reports_repository.dart';

class GetOwnerOccupancyReportUseCase {
  final OwnerReportsRepository repository;

  GetOwnerOccupancyReportUseCase(this.repository);

  Future<Either<Failure, List<OccupancyPropertyEntity>>> call({
    bool forceRefresh = false,
  }) async {
    return await repository.getOccupancyReport(forceRefresh: forceRefresh);
  }
}
