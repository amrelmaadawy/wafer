import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/deed_entity.dart';
import '../repositories/deeds_repository.dart';

class GetDeedsListUseCase {
  final DeedsRepository _repository;

  GetDeedsListUseCase(this._repository);

  Future<Either<Failure, List<DeedEntity>>> call() {
    return _repository.getOwnerDeeds();
  }
}
