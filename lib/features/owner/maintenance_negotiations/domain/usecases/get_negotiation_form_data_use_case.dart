import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/negotiation_form_data_entity.dart';
import '../repositories/maintenance_negotiation_repository.dart';

class GetNegotiationFormDataUseCase
    implements UseCase<NegotiationFormDataEntity, NoParams> {
  final MaintenanceNegotiationRepository repository;

  GetNegotiationFormDataUseCase(this.repository);

  @override
  Future<Either<Failure, NegotiationFormDataEntity>> call(
    NoParams params,
  ) async {
    return await repository.getFormData();
  }
}
