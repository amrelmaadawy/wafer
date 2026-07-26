import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/revenue_report_entity.dart';
import '../repositories/owner_reports_repository.dart';

class GetOwnerRevenueReportParams {
  final bool forceRefresh;
  final int? propertyId;
  final String? startDate;
  final String? endDate;

  const GetOwnerRevenueReportParams({
    this.forceRefresh = false,
    this.propertyId,
    this.startDate,
    this.endDate,
  });
}

class GetOwnerRevenueReportUseCase
    implements UseCase<RevenueReportEntity, GetOwnerRevenueReportParams> {
  final OwnerReportsRepository _repository;

  GetOwnerRevenueReportUseCase(this._repository);

  @override
  Future<Either<Failure, RevenueReportEntity>> call(
      GetOwnerRevenueReportParams params) {
    return _repository.getRevenueReport(
      forceRefresh: params.forceRefresh,
      propertyId: params.propertyId,
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}

