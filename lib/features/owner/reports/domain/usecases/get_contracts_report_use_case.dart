import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/contracts_report_entity.dart';
import '../repositories/owner_reports_repository.dart';

class GetContractsReportUseCase {
  final OwnerReportsRepository repository;

  GetContractsReportUseCase(this.repository);

  Future<Either<Failure, ContractsReportEntity>> call({
    bool forceRefresh = false,
    int page = 1,
    int? propertyId,
  }) async {
    return await repository.getContractsReport(
      forceRefresh: forceRefresh,
      page: page,
      propertyId: propertyId,
    );
  }
}
