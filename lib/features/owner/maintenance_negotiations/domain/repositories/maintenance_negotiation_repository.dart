import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/negotiation_form_data_entity.dart';
import '../entities/negotiations_list_response_entity.dart';

abstract class MaintenanceNegotiationRepository {
  Future<Either<Failure, NegotiationFormDataEntity>> getFormData();
  Future<Either<Failure, NegotiationsListResponseEntity>> getNegotiationsList({
    int page = 1,
    int perPage = 15,
  });
  Future<Either<Failure, NegotiationEntity>> createNegotiation({
    required num approvalLimit,
    required bool isActive,
  });
}
