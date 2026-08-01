import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/legal_case_item_entity.dart';
import '../repositories/legal_cases_repository.dart';

class GetLegalCaseDetailsUseCase {
  final LegalCasesRepository repository;

  GetLegalCaseDetailsUseCase(this.repository);

  Future<Either<Failure, LegalCaseItemEntity>> call(int id) async {
    return await repository.getLegalCaseDetails(id);
  }
}
