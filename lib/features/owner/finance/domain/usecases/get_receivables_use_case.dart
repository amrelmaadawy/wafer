import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/receivable_entity.dart';
import '../repositories/finance_repository.dart';

class GetReceivablesUseCase {
  final FinanceRepository repository;

  const GetReceivablesUseCase(this.repository);

  Future<Either<Failure, List<ReceivableEntity>>> call({
    String? status,
    int? propertyId,
    int page = 1,
  }) {
    return repository.getReceivables(
      status: status,
      propertyId: propertyId,
      page: page,
    );
  }
}
