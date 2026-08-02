import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../repositories/legal_cases_repository.dart';

class DeleteLegalCaseUseCase {
  final LegalCasesRepository repository;

  DeleteLegalCaseUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    return await repository.deleteLegalCase(id);
  }
}
