import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/finance_form_data_entity.dart';
import '../repositories/finance_repository.dart';

class GetFinanceFormDataUseCase {
  final FinanceRepository repository;

  GetFinanceFormDataUseCase(this.repository);

  Future<Either<Failure, FinanceFormDataEntity>> call() async {
    return await repository.getFinanceFormData();
  }
}
