import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../repositories/owner_clients_repository.dart';

class DeleteOwnerClientUseCase {
  final OwnerClientsRepository repository;

  const DeleteOwnerClientUseCase({required this.repository});

  Future<Either<Failure, void>> call(int clientId) async {
    return repository.deleteClient(clientId);
  }
}
