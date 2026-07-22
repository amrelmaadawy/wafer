import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/deed_entity.dart';
import '../repositories/deeds_repository.dart';

class CreateDeedUseCase {
  final DeedsRepository _repository;

  CreateDeedUseCase(this._repository);

  Future<Either<Failure, DeedEntity>> call(Map<String, dynamic> body) {
    return _repository.createDeed(body);
  }
}
