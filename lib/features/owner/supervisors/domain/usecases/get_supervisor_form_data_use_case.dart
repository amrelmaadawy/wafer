import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/supervisor_form_data_entity.dart';
import '../repositories/supervisors_repository.dart';

class GetSupervisorFormDataUseCase
    implements UseCase<SupervisorFormDataEntity, NoParams> {
  final SupervisorsRepository repository;

  GetSupervisorFormDataUseCase(this.repository);

  @override
  Future<Either<Failure, SupervisorFormDataEntity>> call(
    NoParams params,
  ) async {
    return await repository.getFormData();
  }
}
