import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/supervisors_list_response_entity.dart';
import '../repositories/supervisors_repository.dart';

class GetSupervisorsUseCase
    implements UseCase<SupervisorsListResponseEntity, int> {
  final SupervisorsRepository repository;

  GetSupervisorsUseCase(this.repository);

  @override
  Future<Either<Failure, SupervisorsListResponseEntity>> call(int page) async {
    return await repository.getSupervisors(page);
  }
}
