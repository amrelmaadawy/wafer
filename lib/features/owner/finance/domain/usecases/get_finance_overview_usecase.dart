import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/finance_overview_entity.dart';
import '../repositories/finance_repository.dart';

class GetFinanceOverviewUseCase {
  final FinanceRepository repository;

  GetFinanceOverviewUseCase(this.repository);

  Future<Either<Failure, FinanceOverviewEntity>> call() {
    return repository.getFinanceOverview();
  }
}
