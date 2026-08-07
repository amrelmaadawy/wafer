import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/legal_cases_report_entity.dart';
import '../repositories/owner_reports_repository.dart';

class GetLegalCasesReportUseCase
    implements UseCase<LegalCasesReportEntity, GetLegalCasesReportParams> {
  final OwnerReportsRepository repository;

  GetLegalCasesReportUseCase(this.repository);

  @override
  Future<Either<Failure, LegalCasesReportEntity>> call(
    GetLegalCasesReportParams params,
  ) async {
    return await repository.getLegalCasesReport(
      page: params.page,
      status: params.status,
    );
  }
}

class GetLegalCasesReportParams {
  final int page;
  final String? status;

  GetLegalCasesReportParams({
    this.page = 1,
    this.status,
  });
}
