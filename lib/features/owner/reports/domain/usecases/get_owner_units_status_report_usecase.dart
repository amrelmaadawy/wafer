import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/units_status_report_entity.dart';
import '../repositories/owner_reports_repository.dart';

class GetOwnerUnitsStatusReportUseCase
    implements UseCase<UnitsStatusReportEntity, GetOwnerUnitsStatusReportParams> {
  final OwnerReportsRepository repository;

  GetOwnerUnitsStatusReportUseCase(this.repository);

  @override
  Future<Either<Failure, UnitsStatusReportEntity>> call(
      GetOwnerUnitsStatusReportParams params) async {
    return await repository.getUnitsStatusReport(
      forceRefresh: params.forceRefresh,
      page: params.page,
      propertyId: params.propertyId,
      status: params.status,
    );
  }
}

class GetOwnerUnitsStatusReportParams {
  final bool forceRefresh;
  final int page;
  final int? propertyId;
  final String? status;

  GetOwnerUnitsStatusReportParams({
    this.forceRefresh = false,
    this.page = 1,
    this.propertyId,
    this.status,
  });
}
