import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/client_entity.dart';
import '../repositories/owner_clients_repository.dart';

class UpdateOwnerClientUseCase
    implements UseCase<ClientEntity, UpdateOwnerClientParams> {
  final OwnerClientsRepository repository;

  UpdateOwnerClientUseCase({required this.repository});

  @override
  Future<Either<Failure, ClientEntity>> call(
      UpdateOwnerClientParams params) async {
    return await repository.updateClient(
      clientId: params.clientId,
      body: params.body,
    );
  }
}

class UpdateOwnerClientParams {
  final int clientId;
  final Map<String, dynamic> body;

  UpdateOwnerClientParams({
    required this.clientId,
    required this.body,
  });
}
