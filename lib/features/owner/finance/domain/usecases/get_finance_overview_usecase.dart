import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/finance_overview_entity.dart';
import '../repositories/finance_repository.dart';

class GetFinanceOverviewUseCase
    implements UseCase<FinanceOverviewEntity, NoParams> {
  final FinanceRepository repository;

  GetFinanceOverviewUseCase(this.repository);

  @override
  Future<Either<Failure, FinanceOverviewEntity>> call(NoParams params) {
    return repository.getFinanceOverview();
  }
}
