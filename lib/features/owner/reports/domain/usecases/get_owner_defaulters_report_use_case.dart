import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/defaulter_entity.dart';
import '../repositories/owner_reports_repository.dart';

class GetOwnerDefaultersReportUseCase {
  final OwnerReportsRepository repository;

  GetOwnerDefaultersReportUseCase(this.repository);

  Future<Either<Failure, List<DefaulterEntity>>> call({
    bool forceRefresh = false,
  }) async {
    return await repository.getDefaultersReport(forceRefresh: forceRefresh);
  }
}
