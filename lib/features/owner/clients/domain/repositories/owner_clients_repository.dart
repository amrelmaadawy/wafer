import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/clients_list_response_entity.dart';

abstract class OwnerClientsRepository {
  Future<Either<Failure, ClientsListResponseEntity>> getClients({
    int page = 1,
    Map<String, dynamic>? filters,
  });
}
