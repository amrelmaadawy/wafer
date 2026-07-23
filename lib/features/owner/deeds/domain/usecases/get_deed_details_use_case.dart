import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/deed_entity.dart';
import '../repositories/deed_repository.dart';

class GetDeedDetailsUseCase {
  final DeedRepository repository;

  GetDeedDetailsUseCase(this.repository);

  Future<Either<Failure, DeedEntity>> call(int id) async {
    return await repository.getDeedDetails(id);
  }
}
