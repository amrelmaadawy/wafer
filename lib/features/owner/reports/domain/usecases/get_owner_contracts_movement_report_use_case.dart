import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/contracts_movement_report_entity.dart';
import '../repositories/owner_reports_repository.dart';

class GetOwnerContractsMovementReportUseCase {
  final OwnerReportsRepository repository;

  GetOwnerContractsMovementReportUseCase(this.repository);

  Future<Either<Failure, ContractsMovementReportEntity>> call({
    bool forceRefresh = false,
    int page = 1,
  }) {
    return repository.getContractsMovementReport(
      forceRefresh: forceRefresh,
      page: page,
    );
  }
}
