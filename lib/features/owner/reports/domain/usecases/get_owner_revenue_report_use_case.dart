import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/revenue_entry_entity.dart';
import '../repositories/owner_reports_repository.dart';

class GetOwnerRevenueReportParams {
  final bool forceRefresh;
  const GetOwnerRevenueReportParams({this.forceRefresh = false});
}

class GetOwnerRevenueReportUseCase
    implements UseCase<List<RevenueEntryEntity>, GetOwnerRevenueReportParams> {
  final OwnerReportsRepository _repository;

  GetOwnerRevenueReportUseCase(this._repository);

  @override
  Future<Either<Failure, List<RevenueEntryEntity>>> call(
      GetOwnerRevenueReportParams params) {
    return _repository.getRevenueReport(forceRefresh: params.forceRefresh);
  }
}
