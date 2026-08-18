import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/defaulters_report_entity.dart';
import '../repositories/owner_reports_repository.dart';

class GetOwnerDefaultersReportUseCase {
  final OwnerReportsRepository repository;

  GetOwnerDefaultersReportUseCase(this.repository);

  Future<Either<Failure, DefaultersReportEntity>> call({
    bool forceRefresh = false,
    int page = 1,
    int? propertyId,
    String? startDate,
    String? endDate,
  }) async {
    return await repository.getDefaultersReport(
      forceRefresh: forceRefresh,
      page: page,
      propertyId: propertyId,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
