import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/clients_list_response_entity.dart';
import '../repositories/owner_clients_repository.dart';

class GetOwnerClientsParams {
  final int page;
  final Map<String, dynamic>? filters;

  const GetOwnerClientsParams({this.page = 1, this.filters});
}

class GetOwnerClientsUseCase {
  final OwnerClientsRepository repository;

  const GetOwnerClientsUseCase(this.repository);

  Future<Either<Failure, ClientsListResponseEntity>> call(
    GetOwnerClientsParams params,
  ) async {
    return repository.getClients(page: params.page, filters: params.filters);
  }
}
