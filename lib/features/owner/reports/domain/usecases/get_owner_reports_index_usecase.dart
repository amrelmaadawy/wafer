import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/owner_reports_index_entity.dart';
import '../repositories/owner_reports_repository.dart';

class GetOwnerReportsIndexUseCase
    implements UseCase<OwnerReportsIndexEntity, NoParams> {
  final OwnerReportsRepository repository;

  GetOwnerReportsIndexUseCase(this.repository);

  @override
  Future<Either<Failure, OwnerReportsIndexEntity>> call(NoParams params) async {
    return await repository.getReportsIndex();
  }
}
