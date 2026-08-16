import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/payable_entity.dart';
import '../repositories/finance_repository.dart';

class GetPayablesUseCase {
  final FinanceRepository repository;

  const GetPayablesUseCase(this.repository);

  Future<Either<Failure, List<PayableEntity>>> call({
    String? status,
    int? propertyId,
    int page = 1,
  }) {
    return repository.getPayables(
      status: status,
      propertyId: propertyId,
      page: page,
    );
  }
}
