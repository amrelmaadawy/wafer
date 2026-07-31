import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/supervisor_entity.dart';
import '../repositories/supervisors_repository.dart';

class CreateSupervisorUseCase {
  final SupervisorsRepository repository;

  CreateSupervisorUseCase(this.repository);

  Future<Either<Failure, SupervisorEntity>> call(Map<String, dynamic> body) async {
    return await repository.createSupervisor(body);
  }
}
