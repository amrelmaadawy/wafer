import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/negotiation_form_data_entity.dart';
import '../repositories/maintenance_negotiation_repository.dart';

class CreateNegotiationUseCase {
  final MaintenanceNegotiationRepository repository;

  CreateNegotiationUseCase(this.repository);

  Future<Either<Failure, NegotiationEntity>> call(CreateNegotiationParams params) async {
    return await repository.createNegotiation(
      approvalLimit: params.approvalLimit,
      isActive: params.isActive,
    );
  }
}

class CreateNegotiationParams {
  final num approvalLimit;
  final bool isActive;

  CreateNegotiationParams({
    required this.approvalLimit,
    required this.isActive,
  });
}
