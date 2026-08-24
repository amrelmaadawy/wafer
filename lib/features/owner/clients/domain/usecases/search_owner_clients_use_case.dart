import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';

import '../entities/client_entity.dart';
import '../repositories/owner_clients_repository.dart';

class SearchOwnerClientsUseCase {
  final OwnerClientsRepository repository;

  SearchOwnerClientsUseCase(this.repository);

  Future<Either<Failure, List<ClientEntity>>> call(String params) async {
    return await repository.searchClients(params);
  }
}
